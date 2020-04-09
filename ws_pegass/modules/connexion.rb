require 'sinatra/base'
require_relative '../class/pegass'
require_relative '../class/gaia'

module Sinatra
  module PegassApp
    module Connexion
        def self.registered(app)

            app.get '/connect' do

                result = []

                begin    

                    logger.info "Before get_connexion"
                    connexion=get_connexion
                    logger.info "After get_connexion"
                    logger.info "After get_connexion (#{connexion})"
                    
                    result=connexion['res_pegass']
                    result['SAML'] = connexion['res_gaia']['SAML']
                    result['JSESSIONID'] = connexion['res_gaia']['JSESSIONID']
                    result['utilisateur']['gaia_id']=connexion['res_gaia']['utiId']

                    logger.info "Test connexion: #{connexion['pegass_connect']}"
                    
                    if connexion['pegass_connect']
                        status 200
                    else
                        status 401
                    end

                rescue => exception
                    # logger.info exception
                    status 401
                end
                
                "#{result.to_json}"
            end

            app.get '/connecttest' do  
                begin    

                    connexion=get_connexion

                    result=connexion['res_pegass']
                    result['SAML'] = connexion['res_gaia']['SAML']
                    result['JSESSIONID'] = connexion['res_gaia']['JSESSIONID']
                    result['utilisateur']['gaia_id']=connexion['res_gaia']['utiId']
                     
                    if connexion['pegass_connect']
                        status 200
                    else
                        status 401
                    end

                rescue => exception
                    # logger.error exception
                    status 500
                end
                
                "#{result.to_json}"
            end
        end
    end
  end 
end
