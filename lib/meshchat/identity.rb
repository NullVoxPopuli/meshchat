module MeshChat
  module Identity
    module_function

    def check_or_create(overwrite = false, auto_confirm = false)
      # if setup is complete, we don't need to do anything.
      # it's likely the user already went through the setup process
      return if setup_is_completed? and not overwrite

      generate! if auto_confirm or confirm? I18n.t('identity.settings_not_detected')
      # if everything is good, the app can boot
      return Settings.save if setup_is_completed?

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
      MeshChat::Config::Settings.is_complete?
    end

    def generate!
      confirm_uid
      confirm_alias
      confirm_keys
      # TODO: port and ip?
    end

    def confirm_uid
      if Settings.uid_exists?
        Settings.generate_uid if confirm? I18n.t('identity.confirm_uid_replace')
      else
        Settings.generate_uid
      end
    end

    def confirm_alias
      if Settings['alias'].present?
        Display.add_line I18.t('idenity.current_alias', name: Settings['alias'])
        ask_for_alias if confirm? I18n.t('identity.confirm_alias_replace')
      else
        ask_for_alias
      end
    end

    def confirm_keys
      if Settings.keys_exist?
        Settings.generate_keys if confirm? I18n.t('identity.confirm_key_replace')
      else
        Settings.generate_keys
      end
    end

    def ask_for_alias
      Display.add_line I18n.t('identity.ask_for_alias')
      response = gets
      response = response.chomp
      Settings['alias'] = response
    end

    def confirm?(msg)
      Display.warning msg + I18n.t(:confirm_options)
      response = gets
      response = response.chomp
      [I18n.t(:confirm_yes), I18n.t(:confirm_y)].include?(response.downcase)
    end
  end
end
