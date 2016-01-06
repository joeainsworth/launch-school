# If we have these two methods:

# class Computer
#   attr_accessor :template

#   def create_template
#     @template = 'template 14231'
#   end

#   def show_template
#     template
#   end
# end

# class Computer
#   attr_accessor :template

#   def create_template
#     self.template = "template 14231"
#   end

#   def show_template
#     self.template
#   end
# end
#
# There isn't any difference but you should avoid using self where possible. We already have a getter and setter method so there is no need to reference self.
