mkdir media
	find / -name '*.mp3' -type f -exec mv {} media \; 2> /dev/null
	find / -name '*.mov' -type f -exec mv {} media \; 2> /dev/null
	find / -name '*.mp4' -type f -exec mv {} media \; 2> /dev/null
	find / -name '*.avi' -type f -exec mv {} media \; 2> /dev/null
	find / -name '*.mpg' -type f -exec mv {} media \; 2> /dev/null
	find / -name '*.mpeg' -type f -exec mv {} media \; 2> /dev/null
	find / -name '*.flac' -type f -exec mv {} media \; 2> /dev/null
	find / -name '*.m4a' -type f -exec mv {} media \; 2> /dev/null
	find / -name '*.flv' -type f -exec mv {} media \; 2> /dev/null
	find / -name '*.ogg' -type f -exec mv {} media \; 2> /dev/null
	find /home -name '*.gif' -type f -exec mv {} media \; 2> /dev/null
	find /home -name '*.png' -type f -exec mv {} media \; 2> /dev/null
	find /home -name '*.jpg' -type f -exec mv {} media \; 2> /dev/null
	find /home -name '*.jpeg' -type f -exec mv {} media \; 2> /dev/null
