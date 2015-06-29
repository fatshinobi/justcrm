require 'test_helper'

class CompanyPersonTest < ActiveSupport::TestCase
  test "company cant be empty" do
    link = CompanyPerson.new
    link.person = people(:one)
    assert link.invalid?, 'Company person link cant be valid with empty company'
  end

  test "person cant be empty" do
    link = CompanyPerson.new
    link.company = companies(:mycrosoft)
    assert link.invalid?, 'Company person link cant be valid with empty person'
  end

end
