require "institucional_site/version"

require "f1sales_custom/parser"
require "f1sales_custom/source"
require "f1sales_helpers"


module InstitucionalSite
  class Error < StandardError; end
  class F1SalesCustom::Email::Source 
    def self.all
      [
        {
          email_id: 'websiteform',
          name: 'Site Formulário'
        }
      ]
    end
  end
  class F1SalesCustom::Email::Parser
    def parse
      parsed_email = @email.body.colons_to_hash(/(nome|De|E-mail|email|Telefone|telefone|Estado).*?:/, false)
      state = @email.body.colons_to_hash['estado']
      message = ''
      message = @email.body.split('Estado').last.split("\n").drop(1).join("\n") if state

      {
        source: {
          name: F1SalesCustom::Email::Source.all.first[:name],
        },
        customer: {
          name: (parsed_email['nome'] || parsed_email['de']),
          phone: parsed_email['telefone'].tr('^0-9', ''),
          email: parsed_email['email']
        },
        product: '',
        message: message,
      }

    end
  end  
end
