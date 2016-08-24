require 'rubygems'
require 'aws/ec2'

SNAPSHOTS_TO_KEEP = ENV['SNAPSHOTS_TO_KEEP'] || 3

def setTags(snapshot)
  if @client_tag
      snapshot.tags['Client'] = @client_tag
      snapshot.tags['Type'] = 'Prod'
      snapshot.tags['Use'] = 'Storage'
  end
end

def createSnapshot(project_name, volume_id, volume_name)
  ec2 = AWS.ec2
  volume = ec2.volumes[volume_id]
  if volume.exists?
    snapshot = volume.create_snapshot("#{project_name} - #{volume_name} volume backup - created by Jenkins")
    setTags(snapshot)
    puts "Creating a snapshot with ID=#{snapshot.id} of #{snapshot.volume_size}Gb"
  else
    abort "Volume #{volume_id} not found! Aborting..."
  end
end


def getSnapshots(volume_id)
  ec2 = AWS.ec2
  volume_snapshots = Array.new

  ec2.snapshots.each do |snapshot|
     if snapshot.volume_id == volume_id
        volume_snapshots.push(snapshot)
     end
  end

  return volume_snapshots.sort_by {|volume| volume.start_time}.reverse
end

def removeExpiredSnapshots(volume_snapshots)
  if volume_snapshots.length > SNAPSHOTS_TO_KEEP.to_i
     volume_snapshots[SNAPSHOTS_TO_KEEP.to_i..volume_snapshots.length-1].each do |snapshot|
       if snapshot.description =~ /volume backup - created by Jenkins/
          puts "Deleting expired snapshot, created at #{snapshot.start_time}"
          snapshot.delete
       end
     end
  end
end

if ARGV.length != 4 and ARGV.length != 5
  abort "Expecting 4 parameters: project_name volume_id volume_name region [Client tag]"
end

project_name = ARGV[0]
volume_id = ARGV[1]
volume_name = ARGV[2]
region = ARGV[3]
if [ARGV.length == 5]
  @client_tag =ARGV[4]
end

AWS.config({:access_key_id=> ENV['AWS_ACCESS_KEY'], :secret_access_key=> ENV['AWS_SECRET_KEY'], :region => region})

puts "Starting EBS volume #{volume_id} backup in #{region.upcase}"
createSnapshot(project_name, volume_id, volume_name)
snapshots = getSnapshots(volume_id)
removeExpiredSnapshots(snapshots)
puts "Process completed successfully"
