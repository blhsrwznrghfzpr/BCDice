#
# 四則演算を評価するクラス
#
class ArithmeticEvaluator
  # 四則演算を評価する
  # @param [String] expr 評価する式
  # @param [Symbol] round_type 端数処理の設定 :omit 切り捨て, :roundUp 切り上げ, :roundOff 四捨五入
  # @return [Integer]
  def eval(expr, round_type = :omit)
    @tokens = tokenize(expr)
    @idx = 0
    @error = false
    @round_type = round_type

    ret = expr()
    if @error
      return 0
    else
      return ret
    end
  end

  private

  def tokenize(expr)
    expr.gsub(%r{[\(\)\+\-\*/]}) { |e| " #{e} " }.split(' ')
  end

  def add
    ret = mul()

    loop do
      if consume("+")
        ret += mul()
      elsif consume("-")
        ret -= mul()
      else
        break
      end
    end

    return ret
  end
  alias expr add

  def mul
    ret = unary()

    loop do
      if consume("*")
        ret *= unary()
      elsif consume("/")
        ret = div(ret, unary())
      else
        break
      end
    end

    return ret
  end

  def div(left, right)
    case @round_type
    when :roundUp
      (left.to_f / right).ceil
    when :roundOff
      (left.to_f / right).round
    else
      left / right
    end
  end

  def unary
    if consume("+")
      term()
    elsif consume("-")
      -term()
    else
      term()
    end
  end

  def term
    if consume("(")
      ret = expr()
      expect(")")
      return ret
    else
      return expect_number()
    end
  end

  def consume(str)
    if @tokens[@idx] != str
      return false
    end

    @idx += 1
    return true
  end

  def expect(str)
    if @tokens[@idx] != str
      @error = true
    end

    @idx += 1
  end

  def expect_number()
    ret = @tokens[@idx].to_i(10)
    @idx += 1
    return ret
  end
end
