# bash_sys_mon

				**************************Before starting configuration please make sure epel-release is updated**************************
also configure msmtp or ssmtp on regarding your email address.


yum install epel-release


					#For ssmtp configuration in mail follow this process

1. install msmtp
	 yum install msmtp

2. configure msmtp:

	nano ~/ .msmtprc
3. Configaration: 

	defaults
	auth           on
	tls            on
	tls_trust_file /etc/ssl/certs/ca-bundle.crt
	logfile        ~/.msmtp.log

	account gmail
	host           smtp.gmail.com
	port           587
	from           your_email@gmail.com
	user           your_email@gmail.com
	password       your_password

	account default : gmail

4. Set permission
	chomd 600 ~./ .msmtprc

5. Configure in script:

 Function to log and email alerts
	log_and_alert() {
    		local message="$1"
    		echo "$message" >> "$LOG_FILE"
    echo -e "Subject: System Health Alert\n\n$message" | msmtp "$EMAIL"
}


						#For configureing ssmtp follow this process

1. installing ssmtp 
	yum install ssmtp

2. COnfigure file location
	/etc/ssmtp/ssmtp.conf

4. Configuration:
	root=your_email@gmail.com
	mailhub=smtp.gmail.com:587
	AuthUser=your_email@gmail.com
	AuthPass=your_password
	UseTLS=YES
	UseSTARTTLS=YES

5. update revaliases in ssmtp config filder
	local_user:your_gmail_addess@gmail.com:smtp.gmail.com:587



6. Modification in script

Function to log and email alerts
	log_and_alert() {
	    local message="$1"
	    echo "$message" >> "$LOG_FILE"
	    echo -e "Subject: System Health Alert\n\n$message" | ssmtp "$EMAIL"
	}
