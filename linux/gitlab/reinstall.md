## 重装 GITLAB

	omnibus gitlab

### 步骤

	yum erase gitlab
	rm -rf /etc/gitlab /opt/gitlab /var/opt/gitlab
	reboot your system
	rpm -ivh gitlab-7.4.3_omnibus.1-1.el6.x86_64.rpm
	sed -i "s/external_url 'localhost'/external_url 'http:\/\/172.16.0.223'/g" /etc/gitlab/gitlab.rb
	gitlab-ctl reconfigure
	gitlab-ctl restart