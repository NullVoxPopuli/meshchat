module MeshChat
  module Identity
    module_function
    # TODO: look in to i18n, cause all these strings are annoying
    SETTINGS_NOT_DETECTED = 'a settings file was not detected or incomplete, would you like to generate one?'
    UNKNOWN_ERROR_TRY_AGAIN = 'something went wrong with identity creation. try again?'
    SETTINGS_ARE_INVALID = 'settings are invalid'

    def check_or_create(overwrite = false, auto_confirm = false)
      # if setup is complete, we don't need to do anything.
      # it's likely the user already went through the setup process
      return if setup_is_completed? and not overwrite

      generate! if auto_confirm or confirm? SETTINGS_NOT_DETECTEDs
      # if everything is good, the app can boot
      return if setup_is_completed?

      # if something has gone wrong, we'll ask if they want to try again
      return check_or_create(true, true) if confirm? UNKNOWN_ERROR_TRY_AGAIN

      # we failed, and don't want to continue
      alert_and_exit
    end

    def alert_and_exit
      Display.alert SETTINGS_ARE_INVALID
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
        Settings.generate_uid if confirm? 'uid exists, are you sure you want a new identity?'
      else
        Settings.generate_uid
      end
    end

    def confirm_alias
      if Settings['alias'].present?
        ask_for_alias if confirm? 'alias exists, would you like to overwrite it?'
      else
        ask_for_alias
      end
    end

    def confirm_keys
      if Settings.keys_exist?
        Settings.generate_keys if confirm? 'keys exist, overwrite?'
      else
        Settings.generate_keys
      end
    end

    def ask_for_alias
      Display.add_line('Type the name/alias you would like to go by in meshchat: ')
      Settings['alias'] = CLI.get_input
    end

    def confirm?(msg)
      Display.warning(msg + ' (Y/N)')
      response = CLI.get_input
      response = response.chomp
      ['yes', 'y'].include?(response.downcase)
    end
  end
end
