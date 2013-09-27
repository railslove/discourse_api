require 'net/http'
require 'active_support/inflector'
require 'json'

class DiscourseApi::Resource
  attr_accessor :protocol, :host, :port, :api_key, :api_username

  def self.post(args)
    # ruby 1.9.3 for now
    array_args = args.to_a
    method_name, path = array_args[0]
    route_args = {}
    array_args[1..-1].each do |k, v|
      route_args[k] = v
    end

    define_method method_name do |args|
      parsed_path = DiscourseApi::ParsedPath.new(path, route_args)
      perform_request(parsed_path, args, 'post')
    end
  end

  def self.get(args)
    # ruby 1.9.3 for now
    array_args = args.to_a
    method_name, path = array_args[0]
    route_args = {}
    array_args[1..-1].each do |k, v|
      route_args[k] = v
    end
    define_method method_name do |args|
      parsed_path = DiscourseApi::ParsedPath.new(path, route_args)
      perform_request(parsed_path, args, 'get')
    end
  end

  def self.put(args)
    # ruby 1.9.3 for now
    array_args = args.to_a
    method_name, path = array_args[0]
    route_args = {}
    array_args[1..-1].each do |k, v|
      route_args[k] = v
    end
    define_method method_name do |args|
      if route_args[:require].include?(:username) && !args[:username]
        args.merge!(:username => self.api_username)
      end
      parsed_path = DiscourseApi::ParsedPath.new(path, route_args)
      perform_request(parsed_path, args, 'put')
    end
  end

  def api_args(args)
    args.merge(:api_key => self.api_key, :api_username => self.api_username)
  end

  def perform_request(parsed_path, args, request_method)
    parsed_path.validate!(args)
    path, actual_args = parsed_path.generate(args)
    actual_args = api_args(actual_args)
    request_class = "Net::HTTP::#{request_method.camelize}"
    req = request_class.constantize.new(path, initheader = {'Content-Type' =>'application/json'})
    req.body = api_args(actual_args).to_json
    http_client.start {|http| http.request(req) }
  end

  private

    def http_client
      if protocol == 'https'
        client = Net::HTTP.new(host, port)
        client.use_ssl = true
        client.verify_mode = OpenSSL::SSL::VERIFY_NONE
        client
      else
        Net::HTTP.new(host, port)
      end
    end

end
