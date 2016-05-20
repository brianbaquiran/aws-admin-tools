#!/bin/sh
yum update -y

# Install CloudWatch monitoring scripts 
# Documentation: http://docs.aws.amazon.com/AmazonCloudWatch/latest/DeveloperGuide/mon-scripts.html
# Download: http://aws-cloudwatch.s3.amazonaws.com/downloads/CloudWatchMonitoringScripts-1.2.1.zip
yum install -y perl-Switch perl-DateTime perl-Sys-Syslog perl-LWP-Protocol-https
su -l ec2-user "wget http://aws-cloudwatch.s3.amazonaws.com/downloads/CloudWatchMonitoringScripts-1.2.1.zip"
su -l ec2-user "unzip CloudWatchMonitoringScripts-1.2.1.zip"
su -l ec2-user "rm CloudWatchMonitoringScripts-1.2.1.zip"
cat > /home/ec2-user/aws-scripts-mon/crontab << EOF
*/5 * * * * /home/ec2-user/aws-scripts-mon/mon-get-instance-stats.pl --from-cron --mem-util --mem-used --mem-avail --swap-util --swap-used --disk-path=/ --disk-space-util --disk-space-used --disk-space-avail
EOF

# Install Perlbrew http://perlbrew.pl/
# Amazon Linux has perlbrew in the yum repository already
yum install patch gcc make perlbrew -y

# still, we need to initialize perlbrew for the ec2-user and download a perl release
su -l ec2-user -c "perlbrew init"
echo "source ~/perl5/perlbrew/etc/bashrc" >> /home/ec2-user/.bash_profile
su -l ec2-user -c "perlbrew install perl-5.16.3"
# Note: this may take a while! AWS will consider the instance available, and you will be able to SSH
# in as Perlbrew continues building, testing and installing Perl.
