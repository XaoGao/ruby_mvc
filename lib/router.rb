require 'byebug'

class Router
  attr_reader :routes

  def initialize(routes)
    @routes = routes
  end

  def resolve(env)
    path = env['REQUEST_PATH']
    if routes.key?(path)
      ctrl(routes[path]).call
    else
      Controller.new.not_found
    end
    rescue Exception => error
      puts error.message
      puts error.backtrace
      Controller.new.internal_error
  end

  private

  def ctrl(route)
    ctrl_name, ctrl_action = route.split('#')
    klass = Object.const_get "#{ctrl_name.capitalize}Controller"
    klass.new(name: ctrl_name, action: ctrl_action.to_sym)
  end
end
