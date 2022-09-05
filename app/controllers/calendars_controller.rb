class CalendarsController < ApplicationController

  # １週間のカレンダーと予定が表示されるページ
  def index
    getWeek
    @plan = Plan.new
  end

  # 予定の保存
  def create
    Plan.create(plan_params)
    redirect_to action: :index
  end

  private

  def plan_params
    params.require(:plan).permit(:date, :plan)
  end

  def getWeek
    wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']

    # Dateオブジェクトは、日付を保持しています。下記のように`.today.day`とすると、今日の日付を取得できます。
    @todays_date = Date.today
    # 例)　今日が2月1日の場合・・・ Date.today.day => 1日

    @week_days = []

    plans = Plan.where(date: @todays_date..@todays_date + 6)

    7.times do |x|　#数値の繰り返し
      today_plans = []
      plans.each do |plan|
        today_plans.push(plan.plan) if plan.date == @todays_date + x
      end

      wday_num = Date.today.wday + x
      # ②４４行目でwday_numに中身（wdays）を入れれたので、wday_numに入れたWdaysの配列にある曜日をDate.today.wdayで表記する。
      # ③このままだと曜日の数値が増えずにずっと同じ曜日が表示されるので、３２行目ですでに作ってるXを足して繰り返しのたびにプラス１できるようにする。
      if wday_num >= 7　#数字が７を超えると曜日の配列から外れてしまうため、７以上の数字は−７するように条件演算する。
        wday_num = wday_num -7
      end

      days = { month: (@todays_date + x).month, date: (@todays_date + x).day, plans: today_plans, wday: wdays[wday_num] }
      # ①３８行目のwday_numに２２行目のwdaysを代入する。（４３行目の最後のところ）
      @week_days.push(days)
    end
  end
end
