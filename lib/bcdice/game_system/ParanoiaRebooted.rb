# frozen_string_literal: true

module BCDice
  module GameSystem
    class ParanoiaRebooted < Base
      # ゲームシステムの識別子
      ID = 'ParanoiaRebooted'

      # ゲームシステム名
      NAME = 'パラノイア リブーテッド'

      # ゲームシステム名の読みがな
      SORT_KEY = 'はらのいありふうてつと'

      # ダイスボットの使い方
      HELP_MESSAGE = <<~INFO_MESSAGE_TEXT
        ※コマンドは入力内容の前方一致で検出しています。
        ・通常の判定　NDx
        　x：ノードダイスの数.マイナスも可.
        　ノードダイスの絶対値 + 1個(コンピュータダイス)のダイスがロールされる.
        例）ND2　ND-3

        ・ミュータントパワー判定　MPx
          x：ノードダイスの数.
        　ノードダイスの値 + 1個(コンピュータダイス)のダイスがロールされる.
        例）MP2
      INFO_MESSAGE_TEXT

      register_prefix('ND', 'MP')

      def eval_game_system_specific_command(command)
        get_node_dice_roll(command) ||
          get_mutant_power_roll(command)
      end

      private

      def generate_roll_results(dices)
        computer_dice_message = ''
        results = dices.dup
        if results[-1] == 6
          results[-1] = 'C'
          computer_dice_message = '(Computer)'
        end

        return results, computer_dice_message
      end

      def get_node_dice_roll(command)
        debug("eval_game_system_specific_command Begin")

        m = /^ND(-?\d+)$/i.match(command)
        unless m
          return nil
        end

        debug("command", command)

        parameter_num = m[1].to_i
        dice_count = parameter_num.abs + 1

        dices = @randomizer.roll_barabara(dice_count, 6)

        success_rate = dices.count { |dice| dice >= 5 }
        success_rate -= dices.count { |dice| dice < 5 } if parameter_num < 0
        debug(dices)

        results, computer_dice_message = generate_roll_results(dices)

        debug("eval_game_system_specific_command result")

        return "(#{command}) ＞ [#{results.join(', ')}] ＞ 成功度#{success_rate}#{computer_dice_message}"
      end

      def get_mutant_power_roll(command)
        debug("eval_game_system_specific_command Begin")

        m = /^MP(\d+)$/i.match(command)
        unless m
          return nil
        end

        debug("command", command)

        parameter_num = m[1].to_i
        dice_count = parameter_num + 1

        dices = @randomizer.roll_barabara(dice_count, 6)

        failure_rate = dices.count(1)
        condition = failure_rate == 0
        message = condition ? "成功" : "失敗(#{failure_rate})"

        results, computer_dice_message = generate_roll_results(dices)

        debug(dices)

        debug("eval_game_system_specific_command result")

        text = "(#{command}) ＞ [#{results.join(', ')}] ＞ #{message}#{computer_dice_message}"

        Result.new.tap do |r|
          r.text = text
          r.condition = condition
        end
      end
    end
  end
end
