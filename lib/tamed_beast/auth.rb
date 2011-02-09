module TamedBeast::Auth
	def self.included(base)
		#base.class_eval do
			#def current_user
				##@current_user ||= ((session[:user_id] && User.find_by_id(session[:user_id])) || 0)
				#nil
			#end
			#ActionController::Base.helper_method :current_user
		#end

		protected
		def login_required
			if !current_user
				# redirect to login page
				false
			end
		end
	end
end

#ActionView::Base.send :include, TamedBeast::Auth
ActionController::Base.send :include, TamedBeast::Auth


