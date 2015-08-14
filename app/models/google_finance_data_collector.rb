class GoogleFinanceDataCollector

  def self.parse_company_info_at_google_finance_for(sym)
    mechanize = Mechanize.new
    url = "https://www.google.com/finance?q=" + sym
    page = mechanize.get(url)
  end

  def self.create_company_profile(sym)
    profile = parse_company_info_at_google_finance_for(sym)
    name = YahooFinanceDataCollector.company_name(sym)  # it was hard to extract the name at Google Finance...
    description = profile.search(".companySummary").inner_text
    address = profile.search(".sfe-section")[3].inner_text.gsub("- Map"," ")

    map_href_checker = profile.search(".sfe-section")[3].search("a")
    if map_href_checker.length > 0  #not all company have map on GoogleFinance...
        map_href = map_href_checker.first["href"]
        map = "<a href='#{map_href}' target=_>Map</a>"
    else
        map = "N/A"
    end

    sector = profile.search("#sector").inner_text
    industry = profile.search(".g-first a").last.inner_text
    website = profile.search("#fs-chome").inner_text.gsub("\n","")
    number_of_employees = profile.search(".period")[10].inner_text.gsub("\n","")
    profile_hash = { name: name,
                     sector: sector,
                     industry: industry,
                     description: description,
                     address: address,
                     map: map,
                     website: "<a href='#{website}' target=_>Website</a>",
                     :"number of employees" => number_of_employees }
  end

end


# require "mechanize"
# p j = GoogleFinanceDataCollector.create_company_profile("blue")
