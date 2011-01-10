module TamedBeast::Auth
#this is a shell that TamedBeast uses to query the current user - overide in your app controller

	protected
    def login_required
      if !current_user
				# redirect to login page
				return false
			end
    end
    
    def authorized?() 
			true 
			# in your code, redirect to an appropriate page if not an admin
		end

    def current_user
      #@current_user ||= ((session[:user_id] && User.find_by_id(session[:user_id])) || 0)
    end
    
    def admin?
      !current_user.nil? && current_user.admin?
    end
end
