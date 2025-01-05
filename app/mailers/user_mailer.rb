class UserMailer < ApplicationMailer

	# default   # Change this to your sender email address

	# def welcome_email(user)
	#    @user = user
	# #    @name = names
	#    mail(to: @user, subject: 'Welcome to My App' , from: 'thiruhealthguru22@gmail.com')


	# end

    def send_simple_email(user)
        mail(
          to: user, # Replace with the recipient's email
          from: "thiruhealthguru22@gmail.com", # Your email
          subject: "Test Email",
          body: "This is a  mail."
        )
    end

      def confirmation_email(user)
        @user = user
        @url = @user.confirmation_token # Generate confirmation link
        mail(to: @user.email, subject: 'Confirm your account',body: "your confirmation token - #{ @url}")
      end

    def otp_email(user)
    @user = user
    # Generate a random secret for the user (save this securely)
        # secret = ROTP::Base32.random_base32
        # puts "Your secret key: #{secret}"
        # # Generate TOTP using the secret

        totp = ROTP::TOTP.new(user.otp_secrect)
        otp = totp.now # Generate the current OTP
        puts "Your OTP is: #{otp}"
    mail(to: @user.email, subject: 'Otp your account',body: "your OTP  - #{otp}")
    end

    def reminder_task_email(user,task)
      mail(to: user.email, subject: "New task assigned",body: "task Details :-\n\ntask name: #{task.title}\nDue date : #{task.due_date}")
    end

    def task_reminder(task,user)
      mail(to: user.email, subject: "Reminder for task completion",body: "task Details :-\n\ntask name: #{task.title}\nDue date : #{task.due_date}")
    end

end