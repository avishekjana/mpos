class BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_to_subdomain
  before_action :load_schema
  before_action :set_timezone
  before_action :set_subscription_plans

  private

    def redirect_to_subdomain
      return if self.is_a?(DeviseController)
      if current_user.present? && request.subdomain != current_user.tenant.subdomain && self.is_a?(OnboardingController)
        logger.info("\n\nOnboarding URL:: #{onboarding_index_url} \n")
        logger.info("\n\nOnboarding URL with subdomain:: #{onboarding_index_url( :subdomain => current_user.tenant.subdomain )} \n")
        redirect_to onboarding_index_url( :subdomain => current_user.tenant.subdomain )
      elsif current_user.present? && request.subdomain != current_user.tenant.subdomain
        logger.info("\n\nRoot URL:: #{root_url} \n")
        logger.info("\n\nRoot URL with subdomain:: #{root_url( :subdomain => current_user.tenant.subdomain )} \n")
        redirect_to dashboard_index_url( :subdomain => current_user.tenant.subdomain )
      end
    end

    def load_schema
      Apartment::Tenant.switch!('public')
      return unless request.subdomain.present?
      logger.info("\nSchema: #{request.subdomain} \n")
      Apartment::Tenant.switch!(request.subdomain)
    end

    def set_timezone
      zone = current_user.tenant.timezone
      zone ||= 'UTC'
      Time.zone = zone
    end

    def set_subscription_plans
      @subscription_plans = SubscriptionPlan.is_active.sorted_by_price
    end

end
