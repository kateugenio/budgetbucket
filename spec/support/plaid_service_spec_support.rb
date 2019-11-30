module PlaidServiceSpecSupport
  def stub_token_exchange_request
    stubbed_domain = Regexp.new "https://sandbox.plaid.com/item/public_token/exchange"
    stub_request(:post, stubbed_domain).to_return(body: {access_token: 1234, item_id: 5678}.to_json, status: 200)
  end

  def plaid_link_metadata
    {
      public_token: 1234,
      item_id: 5678,
      metadata: {
        institution: {
          name: 'Chase Bank',
        },
        accounts: {
          0 => {
            id: 1,
            name: 'Michael\'s Checking',
            mask: '4441',
            type: 'depository',
            subtype: 'checking'
          },
          1 => {
            id: 2,
            name: 'Michael\'s Savings',
            mask: '4442',
            type: 'depository',
            subtype: 'savings'
          }
        }
      }
    }
  end
end
