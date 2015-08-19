class GoogleFinanceDataCollector
  def self.parse_company_info_at_google_finance_for(sym)
    mechanize = Mechanize.new
    url = "https://www.google.com/finance?q=" + sym
    page = mechanize.get(url)
  end

  def self.data_exist?(property)
    property.length > 0     # check if the property (such as description, name, etc) exists, if it does not, returns an empty array
  end

  def self.profile(sym)
    parse_company_info_at_google_finance_for(sym)
  end

  def self.name(sym)
    YahooFinanceDataCollector.company_name(sym)  # it was hard to extract the name at Google Finance...
  end

  def self.description(sym)
    description = profile(sym).search(".companySummary")
    if data_exist?(description)
      description.inner_text
    else
      "N/A"
    end  
  end

  def self.sector(sym)
    sector = profile(sym).search("#sector")
    if data_exist?(sector)
      sector.inner_text
    else
      "N/A"
    end
  end

  def self.industry(sym)
    industry = profile(sym).search(".g-first a")
    if data_exist?(industry)
      industry.last.inner_text
    else
        "N/A"
    end
  end

  def self.address(sym)
    address = profile(sym).search(".sfe-section")[3]
    if address
      address.inner_text.gsub("- Map"," ")
    else
      "N/A"
    end
  end

  def self.map(sym)
    map_href = profile(sym).search(".sfe-section")[3]
    if map_href  #not all company have map on GoogleFinance...
        return "N/A" if map_href.search("a").empty? #format of Google Finance is not consistant for international stocks
        map_href = map_href.search("a").first["href"]
        "<a href='#{map_href}' target=_>Map</a>"
    else
        "N/A"
    end
  end

  def self.website(sym)
    website = profile(sym).search("#fs-chome")
    if data_exist?(website)
        url = website.inner_text.gsub("\n","")
        "<a href='#{url}' target=_>Website</a>"
    else
        "N/A"
    end
  end

  def self.number_of_employees(sym)
    number_of_employees = profile(sym).search(".period")[10]
    if number_of_employees
        number_of_employees.inner_text.gsub("\n","")
    else
        "N/A"
    end
  end

  def self.create_company_profile(sym)
    { name: name(sym),
     sector: sector(sym),
     industry: industry(sym),
     description: description(sym),
     address: address(sym),
     map: map(sym),
     website: website(sym),
     :"number of employees" => number_of_employees(sym) }
  end

end


# require "mechanize"
# p j = GoogleFinanceDataCollector.map("uvxy")
