require 'slim'

class Controller
  attr_reader :name, :action
  attr_accessor :status, :headers, :content

  def initialize(name: nil, action: nil)
    @name = name
    @action = action
  end

  def call
    send(action)
    self.status = 200
    self.headers = { 'Content-Type' => 'text/html' }
    self.content = [template.render(self)]
    self
  end

  def not_found
    self.status = 404
    self.headers = {}
    self.content = ['Not found']
    self
  end

  def internal_error
    self.status = 500
    self.headers = {}
    self.content = ['Internal error']
    self
  end

  def template
    path = File.join(App.root, 'app', 'views', "#{self.name}", "#{self.action}.slim")
    Slim::Template.new(path)
  end
end
