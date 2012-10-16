class PLCRational

	# constructor 
	def initialize(num, den = 1) # default
		#if (den == 0)
		#	raise "Gah! Zero divisor!"
		#end
		raise "Gah! Zero divisor!" if (den == 0)
		@num = num # @num refers to the instance variable num
		@den = den # @den refers to the instance variable den 
	end

	def inspect
		"#{@num.to_s} / #{@den.to_s}"
	end

	def to_s
		s = @num.to_s
		s = s + " / " + @den.to_s if (@den != 1)
		s # this means "return s", we could do an explicit return too, value of last statement method is automatically returned
	end

	# add to self
	def add(r)
		a = r.num
		b = r.den
		c = @num
		d = @den

		@num = (a * d) + (c * b)
		@den = b * d
		self # convenient for subsequent method calls
	end

	# functional add
	def + r
		ans = PLCRational.new(@num, @den)
		ans.add(r)
	end

	#protected 
	# subsequent methods are protected, until another access/visibility keyword
	#def num
	#	@num
	#end 

	#def den
	#	@den
	#end	

	# we could rewrite these as folows...
	protected #:num, :den
	attr_reader :num, :den
end

# methods outside a class become part of the "main" class,
# which is available in the rep-loop

def double1 x
	x + x # sugar fo x.+(x)
end

def double2 x
	x * 2
end

def double3 x
	2 * x
end