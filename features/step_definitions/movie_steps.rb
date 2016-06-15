# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
  	Movie.create(movie)
	end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  
  # first try
  # titles = page.all("table#movies tbody tr td[1]").map {|td| td.text}
  # titles.index(e1).should < titles.index(e2)
  
  # second try
  /#{e1}.*?#{e2}/m.should match(page.body)
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(',').map(&:strip).each do |rating|
    if uncheck
      steps %Q{When I uncheck "ratings_#{rating}"}
    else
      steps %Q{When I check "ratings_#{rating}"}
    end
  end
end

Then /^I should see all the movies$/ do
    rows = page.all("table#movies tbody tr td[1]")
    rows.size.should == Movie.count
end