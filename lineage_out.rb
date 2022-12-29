require 'rainbow'
require 'colorize'





##### 리니지m 망하기 기원 #####
def abcdf_lineage(want_card_name="", free_pass=false)
    want_card_name = want_card_name

    if want_card_name != "" && free_pass != false
        card_sum_data = lineage_card_list(want_card_name, free_pass)
        gets.chomp
    else
        puts "보유한 다이아를 입력해주세요 : (최대보유다이아 : 1,000,000개)" #보유한 다이아 맥시멈 20만인데 언제든 수정하면 되는거니깐..
        my_dia = gets.chomp

        if my_dia != "" && my_dia.to_i <= 1000000 # 공백으로 들어올수도있으니 공백이 아니고 맥시멈 20만개보다 적으면 진행
            puts Rainbow("보유한 다이아는 #{my_dia}개 입니다.").green
            puts Rainbow("리니지M 병신뽑기(10+1) 입니다 1회 1200다이아 소모됩니다").yellow
            puts "하겠다= ENTER 안하겠다= N"
            do_you_want_drawing = gets.chomp

            if do_you_want_drawing == ""
                if my_dia.to_i >= 1200
                    puts Rainbow("리니지M 병신뽑기가 시작됩니다!!").green
                    remain = lineage_draw_card(my_dia)
                    have_dia = remain[0] # 뽑기하고 남은 다이아
                    draw_cnt = remain[1] # 뽑기를 몇 회 진행했는가.
                    white_cnt_sum =  remain[2] # 뽑은 일반등급의 총 합
                    green_cnt_sum =  remain[3] # 뽑은 고급등급의 총 합
                    blue_cnt_sum =  remain[4] # 뽑은 희귀등급의 총 합
                    red_cnt_sum =  remain[5] # 뽑은 영웅등급의 총 합


                    puts Rainbow("다이아 #{my_dia}개 로시작해서 뽑기#{draw_cnt}회 진행하고 남은다이아는 #{have_dia}개 입니다").yellow
                    puts "======최종뽑은 카드결과======"
                    puts "      일반등급 : #{white_cnt_sum} 장"
                    puts "      고급등급 : #{green_cnt_sum} 장".colorize(:green)
                    puts "      희귀등급 : #{blue_cnt_sum} 장".colorize(:blue)
                    puts "      영웅등급 : #{red_cnt_sum} 장".colorize(:red)
                    puts "============================="

                    # puts "일반 #{card_cnt[0]}장, 고급 #{card_cnt[1]}장, 희귀 #{card_cnt[2]}장, 영웅 #{card_cnt[3]}장" # 각 등급별 몇 장씩 먹었는가. 추가예쩡
                    # 사용한 다이아 대비 각 등급이 몇%비율로 획득하였는가 ? 추가예정
                else
                    need_more_dia = 1200 - my_dia.to_i
                    puts Rainbow("다이아도 #{my_dia}개 밖에 없으면서 어딜..#{need_more_dia}개 더 가져와라..").red
                end
            elsif do_you_want_drawing.to_s.upcase == "N"
                puts Rainbow("안할껀데 왜 눌러..").red
            end
        else 
            puts Rainbow("말 거참 드럽게 안듣네...탈락").red
        end
    end
end


def lineage_draw_card(my_dia)
    my_dia = my_dia
    draw_card_cnt = my_dia.to_i / 1200 # 1판에 1200개니 나누기 해서 횟수를 구한다.
    puts Rainbow("총 #{draw_card_cnt}회 진행이 가능합니다.").yellow
    continue_check = true # 직접 클릭해서 뽑을수도 있지만 자동으로 .. 한마디로 실제 게임에서는 모두열기 확인위해서
    
    
    # 등급별 카드 카운팅을 위한 배열 생성
    white_card_all_cnt_a = Array.new
    green_card_all_cnt_a = Array.new
    blue_card_all_cnt_a = Array.new
    red_card_all_cnt_a = Array.new

    for i in 1..draw_card_cnt # 기본적으로 횟수만큼 진행한다. 원하면 중간에 안할수있다. while 해야되나? 아..
        my_dia = my_dia.to_i - 1200 # 1회에 1200개씩 차감
        puts ""
        puts Rainbow("#{i}회차 드로우~").green
        card_sum_data = lineage_card_list() # 실제 병신카드 뽑아서 나오는 함수.
        white_card_all_cnt_a << card_sum_data[0] # 일반등급
        green_card_all_cnt_a << card_sum_data[1] # 고급등급
        blue_card_all_cnt_a << card_sum_data[2] # 희귀등급
        red_card_all_cnt_a << card_sum_data[3] # 영웅등급

        puts "" 
        puts "남은 다이아 #{my_dia}개 입니다"
        if continue_check == true
            puts "계속 진행하겠습니까? (OK=ENTER STOP=N AUTO=O) : " # 엔터는 진행 N 은 정지  o 는 자동으로 다이아를 다 소모할때까지 진행
            continue_draw = gets.chomp
        end



        if continue_draw == "" 
            if my_dia.to_i >= 1200 # 한다고 버튼(엔터)는 눌렀는데 다이아가 부족할수있으니 확인. 다이아가 충분하다면 진행
                next
            else
                charging_dia = 1200 - my_dia.to_i
                puts Rainbow("남은다이아 #{my_dia}개 입니다 #{charging_dia}개 충전해오세요")
            end
        elsif continue_draw.to_s.upcase == "N"
            puts Rainbow("어유 더 돌리면 나올텐데~~ ㅉㅉ").red

            # 각 등급별 모든 회차에 카운팅의 합 구하기
            white_card_all_cnt_a =  white_card_all_cnt_a.sum
            green_card_all_cnt_a =  green_card_all_cnt_a.sum
            blue_card_all_cnt_a =  blue_card_all_cnt_a.sum
            red_card_all_cnt_a =  red_card_all_cnt_a.sum

            return [my_dia, i, white_card_all_cnt_a, green_card_all_cnt_a, blue_card_all_cnt_a, red_card_all_cnt_a] #0 번째는 남은 다이아 , 1번째는 돌린횟수 
        elsif continue_draw.to_s.upcase == "O"
            continue_check = false #오토를 선택했으면 컨티뉴 체크를 false 를 줘서 gets.chomp (진행할지 말지 여부를 확인하는곳)을 넘어간다
            if my_dia.to_i >= 1200
                sleep 0.2
                next
            end
        end
    end
    

    # 각 등급별 모든 회차에 카운팅의 합 구하기
    white_card_all_cnt_a =  white_card_all_cnt_a.sum
    green_card_all_cnt_a =  green_card_all_cnt_a.sum
    blue_card_all_cnt_a =  blue_card_all_cnt_a.sum
    red_card_all_cnt_a =  red_card_all_cnt_a.sum

    return [my_dia, i, white_card_all_cnt_a, green_card_all_cnt_a, blue_card_all_cnt_a, red_card_all_cnt_a] #0 번째는 남은 다이아 , 1번째는 돌린횟수 
end


# 리니지M 일반, 고급, 희귀, 영웅 카드들을 가지고 (수정중)확률에 맞게 뽑아내는 작업을 하는 함수
def lineage_card_list(want_my_card="", free_pass=false) 
    white_card_list = ['강철의 문 기사', '버그베어', '킹 버그베어', '늑대인간', '해골', '오크', '오크 궁수', '서큐버스', '추적자 칼', '장로', '해골 궁수', '해골 창병', '두다-마라 오크', '오크 전사', '오크 스카우트', '다크엘프 위자드', '만다린 오렌지', '산적 궁수', '키위패롯', '젤라틴 큐브', '라이칸스로프', '꼬꼬마(분홍)', '미들오움', '맘보토끼', '거대 개미', '눈 사람', '페이퍼 맨', '라쿤', '고블린', '임프장로', '해적 사냥꾼 레오', '매직 솔져', '사냥꾼 데일']
    green_card_list = ['블레이즈', '데스나이트', '랜스 마스터', '난쟁이', '흑기사', '다크엘프', '올딘', '흑장로', '드레이크', '랜서', '어쌔신 마스터', '다이노스 타자', '스톤 골렘', '다이노스 투수', '바다 하피', '타락한 케레니스', '불타는 궁수', '바운티 헌터', '환몽', '유카', '산적 두목', '샌드웜 병사', '에르자베 병사']
    blue_card_list = ['홀리 매지션', '레드 매지션', '암살군왕 슬레이브', '실버 쉐도우', '마수군왕 바란카', '데몬', '명법군왕 헬바인', '하이네 경비병', '마령군왕 라이아', '하피', '소드 마스터', '위자드리 마스터', '쉐도우 마스터', '아크 쉐도우', '아크 스카우터', '아크 위자드', '발록', '붉은 오크', '오우거 킹', '다크 머스킷티어', '리칸트', '실버 머스킷티어', '거대 미노타우르스', '블릿 마스터', '아크 머스킷티어', '강철의 문 기사 단장', '페르페르', '펠리컬', '마이노', '놀', '추적자 카이', '아크 드래곤 나이 트', '체인 소드 마스터', '낚시 소년 폴', '실버 드래곤 나이트', '다크 드래곤 나이트', '맘보토끼(당근)', '다크 리퍼', '실버 리퍼', '사이드 마스터', '아크 리퍼', '생일 축하 괴물', '생일 축하 요정', '호랑이', '금빛 슬레이브', '금빛 엔디아스', '대법관 케이나', '대법관 라미아스', '대법관 이데아', '대법관 티아메스', '대법관 바로 메스', '대법관 엔디아스', '대법관 비아타스', '진 데스나이트', '해적 사냥꾼 진', '진 다크엘프', '소녀 케레니스', '나이트 워치', '오렌 보우', '오렌 스피어', '아덴  엘리트 나이트', '아덴 랜서', '아덴 나이트', '하이네 랜서', '하이네 나이트', '하이네 아처', '포노스 오크 전사', '포노스 오크 마법사', '포노스 오크 궁수', '진돗개', '악몽의 허수아비', '알폰스', '라반', '성지의 드워프 도끼병', '성지의 드워프 궁수', '다크엘프 가드', '성지의 드워프 창병', '다크엘프 시프', '성지의 드워프 검사', '에르자베 대장', '샌드웜 대장', '허수아비(블루)', '무덤 가디언 메이지', '무덤 가디언 나이트', '무덤 가디언', '엘모어 장군', '엘모어 병사', '엘모어 마법사', '엘리 트 매직 솔져', '오크 워리어', '오크 액스', '오크 보우', '오크 소드', '고스트', '위치', '펌프킨', '애로우 마스터', '아크 나이트', '블랙 위자드', '다크 나이트', '다크 매지스터', '다크 쉐도우', '다크 레인저', '사냥꾼 리델', '실버 레인저', '실버 나이트', '실버 매지스터']
    red_card_list = ['진 데스나이트(레드)', '경비병 (창) 레드', '천상의 수호 기사', '경비병 (활) 레드', '가문의 수호자 필리아', '케플리샤', '판', '데스', '진 데스나이트(블루)', '크리스터(활)', '아스테어', '가시공주 아이비', '각성 켄라우헬', '단테스', '블루디카', '이실로테(총)', '데포로쥬', '질리언', '이실로테', '오웬(그린)', '레오파드맨', '눈의 리자드맨', '차만카', '고대 펭귄', '경비병 (창) 그린', '경비병 (활) 그린', '악몽의 잭 오 랜턴', '각성 알폰스', '리즈', '백작 안토리오', '사단장 하퍼', '토끼 소 녀', '판도라', '오웬(블루)', '잭 오 랜턴(레드)', '거대한 무덤 가디언', '랜스 마스터(레드)', '어쌔신 마스터(레드)', '금빛 블레이즈', '랜스 마스터(블루)', '발키리  에이르', '유니크 나이트', '유니크 레인저', '유니크 매지션', '경비병 (창)', '유니크 랜서', '경비병 (활)', '지옥의 잭 오 랜턴', '천상의 기사', '군터', '케레니스', '바포메트', '커츠', '헬바인', '켄라우헬', '베레스', '조우', '세바스찬', '데스나이트 (불)', '데스나이트 (골드)', '각성발록', '암흑기사단 릴리']
    

    # all_card_list = [white_card_list, green_card_list, blue_card_list, red_card_list]

    if want_my_card != "" && free_pass != false
        all_card_list = [white_card_list, green_card_list, blue_card_list, red_card_list]
        for i in 0..all_card_list.length - 1
            if i == 0 && white_card_list.include?(want_my_card) == true
                puts "일반등급 #{want_my_card}카드를 뽑을때까지 진행하겠습니다."
            elsif i == 1 && green_card_list.include?(want_my_card) == true
                puts "고급등급 #{want_my_card}카드를 뽑을때까지 진행하겠습니다.".colorize(:green)
            elsif i == 2 && blue_card_list.include?(want_my_card) == true
                puts "희귀등급 #{want_my_card}카드를 뽑을때까지 진행하겠습니다.".colorize(:blue)
            elsif i == 3 && red_card_list.include?(want_my_card) == true
                puts "영웅등급 #{want_my_card}카드를 뽑을때까지 진행하겠습니다.".colorize(:red)
            end
        end
        target_draw_card(want_my_card, all_card_list)
    else
        # 11장을 뽑는데 각 1장마다 카드의등급을 정하기 위한 작업 
        draw_card_a = Array.new
        for i in 0..10
            draw_card_a << rand(1.0..100.0).round(2)
        end
        

        # 실제로 카드를 뽑을 등급별 카운트 
        white_cnt = 0
        green_cnt = 0
        blue_cnt = 0
        red_cnt = 0
        

        darw_card_color_white = Array.new # 일반등급
        darw_card_color_green = Array.new # 녹색등급
        darw_card_color_blue = Array.new # 희귀등급
        darw_card_color_red = Array.new # 영웅등급
        
        # draw_card_a 에 각 등급에 맞는 임의의수가 들어가 있고 그 수가 해당 등급 카드 범위에 들어오면 cnt + 1 해서 뽑을 카드수를 정한다.
        draw_card_a.each do |draw_card_num|
            case draw_card_num
            when 1.0..79.39 then 
                white_cnt += 1
            when 79.40..99.40 then 
                green_cnt += 1
            when 99.41..99.91 then 
                blue_cnt += 1
            when 99.92..100.0 then 
                red_cnt += 1
            else
                puts "draw_card_num : #{draw_card_num}"
                puts "여기는 절때 안온다."
                gets.chomp
            end
        end
        
        
        

        # 각카드 등급의 카운트의 값만큼 해당등급 카드 리스트에서 n장을 뽑는다.
        # 카드 카운트가 0 일때 배열에 "error"를 준 이유는 총 카드리스트를 가지고 작업을 하는데 nil 값이면 값을 못구해서..


        random_card_result = Array.new

        if white_cnt != 0
            white_card_result = white_card_list.sample(white_cnt)
        else
            white_card_result = ["error"]
        end
        
        if green_cnt != 0
            green_card_result = green_card_list.sample(green_cnt)
        else
            green_card_result = ["error"]
        end
        
        if blue_cnt != 0
            blue_card_result = blue_card_list.sample(blue_cnt)
        else
            blue_card_result = ["error"]
        end
        
        if red_cnt != 0
            red_card_result = red_card_list.sample(red_cnt)
        else
            red_card_result = ["error"]
        end
        
        # 모든 카드 결과값(카드)의 전체 리스트
        random_card_result = white_card_result + green_card_result + blue_card_result + red_card_result #
        random_card_result.each do |i|
            if i == "error" # 리스트 안에 "error"가 있으면 다음으로 
                next
            elsif white_card_list.include?(i)
                darw_card_color_white << i
                print i + ","
            elsif green_card_list.include?(i)
                darw_card_color_green << i
                print i.colorize(:green) + ","
            elsif blue_card_list.include?(i)
                darw_card_color_blue << i
                print i.colorize(:blue) + ","
            elsif red_card_list.include?(i)
                darw_card_color_red << i
                print i.colorize(:red) + ","
            else
                puts "이럴리가 없어 절대로"
            end
        end
        return [white_cnt, green_cnt, blue_cnt, red_cnt] # 총 등급별 카운팅
    end
end



def target_draw_card(want_my_card, all_card_list)
    white_card_list = all_card_list[0] # 일반등급카드들
    green_card_list = all_card_list[1] # 고급등급카드들
    blue_card_list = all_card_list[2] # 희귀등급카드들
    red_card_list = all_card_list[3] # 영웅등급카드들


    darw_card_white_a = Array.new # 일반등급
    darw_card_green_a = Array.new # 녹색등급
    darw_card_blue_a = Array.new # 희귀등급
    darw_card_red_a = Array.new # 영웅등급

    check_cnt = 1
    check_dia = 1200
    draw_card_a = Array.new

    while true
        draw_card_a = [] # 뭔지는 모르겠지만 초기화를 해야될거같은 생각이 들었음 안그러면 계속 리스트가  + + + 가 됨
        if check_dia > 9000000
            puts Rainbow("아니 100만 다이아를 써도 못 뽑는데 포기해라 그냥 NC발").red
            break
        end

        puts Rainbow("현재 #{check_cnt}회차! 사용한 다이아 #{check_dia}개!").yellow
        # sleep(0.2)
        for i in 0..10
            draw_card_a << rand(1.0..100.0).round(2)
        end

        # 실제로 카드를 뽑을 등급별 카운트 
        white_cnt = 0
        green_cnt = 0
        blue_cnt = 0
        red_cnt = 0
        
        
        # draw_card_a 에 각 등급에 맞는 임의의수가 들어가 있고 그 수가 해당 등급 카드 범위에 들어오면 cnt + 1 해서 뽑을 카드수를 정한다.
        draw_card_a.each do |draw_card_num|
            case draw_card_num
            when 1.0..79.39 then 
                white_cnt += 1
            when 79.40..99.40 then 
                green_cnt += 1
            when 99.41..99.91 then 
                blue_cnt += 1
            when 99.92..100.0 then 
                red_cnt += 1
            else
                puts "draw_card_num : #{draw_card_num}"
                puts "여기는 절때 안온다."
                gets.chomp
            end
        end

        random_card_result = Array.new


        if white_cnt != 0
            white_card_result = white_card_list.sample(white_cnt)
        else
            white_card_result = ["error"]
        end
        
        if green_cnt !=0
            green_card_result = green_card_list.sample(green_cnt)
        else
            green_card_result = ["error"]
        end
        
        if blue_cnt != 0
            blue_card_result = blue_card_list.sample(blue_cnt)
        else
            blue_card_result = ["error"]
        end
        
        if red_cnt != 0
            red_card_result = red_card_list.sample(red_cnt)
        else
            red_card_result = ["error"]
        end
        

        # 모든 카드 결과값(카드)의 전체 리스트
        random_card_result = white_card_result + green_card_result + blue_card_result + red_card_result 

        if ! white_card_result.to_s.include?("error")
            darw_card_white_a << white_card_result
        elsif ! white_card_result.to_s.include?("error")
            darw_card_green_a << green_card_result
        elsif ! white_card_result.to_s.include?("error")
            darw_card_blue_a << blue_card_result
        elsif ! white_card_result.to_s.include?("error")
            darw_card_red_a << red_card_result
        end

        random_card_result.each do |i|
            if i == want_my_card
                puts Rainbow("총 #{check_cnt}회 만에 다이아 #{check_dia}개를 사용하여 #{want_my_card}카드를 뽑았습니다! ").green
                puts Rainbow("뽑기를 종료합니다!").yellow
                return "success"
            end
        end
        check_cnt += 1
        check_dia += 1200
    end
    return ["fail", darw_card_white_a, darw_card_green_a, darw_card_blue_a, darw_card_red_a]
end



print("1.특정카드 연속뽑기(뽑을때까지) 2. 10+1 뽑기 : ")
choice_job = gets.chomp
if choice_job == "1"
    free_pass= true
    print("뽑고 싶은 카드를 입력하세요 : ")
    want_card_name = gets.chomp.force_encoding('utf-8')
    puts want_card_name.to_s
    gets.chomp
    abcdf_lineage(want_card_name, free_pass)
elsif choice_job == "2"
    abcdf_lineage()
else
    puts "잘못입력했다네.."
end





