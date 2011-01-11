module TamedBeast
  if defined? Rails
    require 'tamed_beast/engine'
    require 'tamed_beast/auth'
    require 'tamed_beast/application_helper'
  end
end
