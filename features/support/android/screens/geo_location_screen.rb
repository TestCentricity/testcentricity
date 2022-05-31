class GeoLocationScreen < BaseAppScreen
  trait(:page_name)    { 'Geo Location' }
  trait(:page_locator) { { accessibility_id: 'geo location screen' } }
  trait(:page_url)     { 'geo-locations' }
  trait(:navigator)    { nav_menu.open_geo_location }

  # Geo Location screen UI elements
  buttons start_observing_button: { accessibility_id: 'Start Observing button'},
          stop_observing_button:  { accessibility_id: 'Stop Observing button'}
  labels  latitude_data:          { accessibility_id: 'latitude data' },
          longitude_data:         { accessibility_id: 'longitude data' }

  def verify_page_ui
    super
    ui = {
      header_label           => { visible: true, caption: 'Geo Location' },
      start_observing_button => { visible: true, enabled: false, caption: 'Start Observing' },
      stop_observing_button  => { visible: true, enabled: true, caption: 'Stop Observing' },
      latitude_data          => { visible: true, caption: { not_equal: '0' } },
      longitude_data         => { visible: true, caption: { not_equal: '0' } }
    }
    verify_ui_states(ui)
  end

  def modal_action(action)
    grant_modal.await_and_respond(action.downcase.to_sym, timeout = 1, button_name = 'Only this time')
  end
end
