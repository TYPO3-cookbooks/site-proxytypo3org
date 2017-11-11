source "http://chef.typo3.org:26200"
source "https://supermarket.chef.io"

metadata

solver :ruby, :required

def fixture(name)
  cookbook name, path: "test/fixtures/cookbooks/#{name}"
end

group :integration do
  cookbook 'apt'
  fixture 'site-proxytypo3org_test'
end
