module SystemCapture
  IMG_PATTERN_NAME = "screen-uid-.png"
  HTML_PATTERN_NAME = "page-uid-.png"

  # Capture system state: browser page screenshot and page source
  def self.capture(browser, spec_uid)
    FileUtils.mkdir_p($log_dir) unless File.directory?($log_dir)

    if browser
      create_screenshot browser, spec_uid
      save_page_source browser, spec_uid
    end
  end


  def self.get_screenshot_path(uid)
    img_name = IMG_PATTERN_NAME
    img_name[/-.*-/] = "-#{uid}-"
    "#{$log_dir}/#{img_name}"
  end

  def self.get_html_path(uid)
    html_name = HTML_PATTERN_NAME
    html_name[/-.*-/] = "-#{uid}-"
    "#{$log_dir}/#{html_name}"
  end

  def self.get_log_path(uid)
    "#{$log_dir}/#{uid}.log"
  end


  private


  def self.create_screenshot(browser, spec_uid)
    browser.save_screenshot(get_screenshot_path(spec_uid)) if browser
  end

  def self.save_page_source(browser, spec_uid)
    File.open(get_html_path(spec_uid), "w") { |f| f.write browser.page_source } if browser
  end

end