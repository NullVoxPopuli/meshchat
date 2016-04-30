# frozen_string_literal: true
module Meshchat
  module Configuration
    module Identity
      module_function

      def check_or_create(overwrite = false, auto_confirm = false)
        # if setup is complete, we don't need to do anything.
        # it's likely the user already went through the setup process
        return if setup_is_completed? && !overwrite

        generate! if auto_confirm || confirm?(I18n.t('identity.settings_not_detected'))
        # if everything is good, the app can boot
        return APP_CONFIG.user.save if setup_is_completed?

        # if something has gone wrong, we'll ask if they want to try again
        return check_or_create(true, true) if confirm? I18n.t('identity.unknown_error_try_again')

        # we failed, and don't want to continue
        alert_and_exit
      end

      def alert_and_exit
        Display.alert I18n.t('identity.settings_are_invalid')
        exit(1)
      end

      def setup_is_completed?
        APP_CONFIG.user.is_complete?
      end

      def generate!
        confirm_uid
        confirm_alias
        confirm_keys
        # TODO: port and ip?
      end

      def confirm_uid
        if APP_CONFIG.user.uid_exists?
          APP_CONFIG.user.generate_uid if confirm? I18n.t('identity.confirm_uid_replace')
        else
          APP_CONFIG.user.generate_uid
        end
      end

      def confirm_alias
        if APP_CONFIG.user['alias'].present?
          Display.add_line I18.t('idenity.current_alias', name: APP_CONFIG.user['alias'])
          ask_for_alias if confirm? I18n.t('identity.confirm_alias_replace')
        else
          ask_for_alias
        end
      end

      def confirm_keys
        if APP_CONFIG.user.keys_exist?
          APP_CONFIG.user.generate_keys if confirm? I18n.t('identity.confirm_key_replace')
        else
          APP_CONFIG.user.generate_keys
        end
      end

      def ask_for_alias
        Display.add_line I18n.t('identity.ask_for_alias')
        response = gets
        response = response.chomp
        APP_CONFIG.user['alias'] = response
      end

      def confirm?(msg)
        Display.warning msg + I18n.t(:confirm_options)
        response = gets
        response = response.chomp
        [I18n.t(:confirm_yes), I18n.t(:confirm_y)].include?(response.downcase)
      end
    end
  end
end
