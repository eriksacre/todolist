module JsHelpers
  def wait_for_ajax
    expect(page.document).to have_selector("body.ajax-completed")
  end
  
  def positive_confirmation
    page.evaluate_script('window.confirm = function() { return true; }')
  end
  
  def catch_alert
    page.evaluate_script('window.lastAlertMsg = "";')
    page.evaluate_script('window.location.reload = function() {};')
    page.evaluate_script('window.alert = function(msg) { window.lastAlertMsg = msg; };')
    yield
    @last_alert_message = page.evaluate_script('window.lastAlertMsg')
  end
end