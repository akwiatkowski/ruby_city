# Additional math functions

class MathUtils
  def self.nonlinear_a( x )

    # f(x) = (0.5+0.5∙(2∙x−1)^3)
    # f(x) = 1/(1+(x∙3)^3)
    # g(x) = ( 0.6+( 1∙x + 5∙(x−0.5)^3 ) ) ∙ 0.47


    #    return 0.0 if x < 0.0
    #    return 1.0 if x > 1.0
    #
    #    if x < 0.5
    #      return x ** 2
    #    else
    #      return ( 1.0 - 2.0 * ( 1.0 - x ) ** 3 )
    #    end

    # g(x) = ( 0.15+( 1∙x + 5∙(x−0.5)^5 ) ) ∙ 0.8

    return 0.0 if x < 0.0
    return 1.0 if x > 1.0

    y = ( 0.15 + ( 1*x + 5*(x - 0.5) ** 5 ) ) * 0.8

    return 0.0 if y < 0.0
    return 1.0 if y > 1.0
    return y

  end
end
