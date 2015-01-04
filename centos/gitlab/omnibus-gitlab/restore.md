## Restore

	omnibus gitlab

### 恢复为备份文件 1419904180_gitlab_backup

	rm -rf /var/opt/gitlab/backups/*
	cp 1419904180_gitlab_backup.tar /var/opt/gitlab/backups/
	gitlab-rake gitlab:backup:restore