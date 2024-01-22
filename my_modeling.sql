/*
   회원          주문              상품
   ----------------------------------------
   번호PK      번호PK          번호PK
   ----------------------------------------
   아이디U, NN   날짜NN          이름NN
   비밀번호NN   회원번호FK, NN   가격D=0
   이름NN      상품번호FK, NN   재고D=0
   주소NN
   이메일
   생일
*/
create table tbl_user(
    id bigint primary key,
    user_id varchar(255) not null unique,
    password varchar(255) not null,
    name varchar(255) not null,
    address varchar(255) not null,
    email varchar(255),
    birth date
);

create table tbl_product(
    id bigint primary key,
    name varchar(255) not null,
    price int default 0,
    stock int default 0
);

create table tbl_order(
    id bigint primary key,
    order_date datetime default current_timestamp,
    user_id bigint not null,
    product_id bigint not null,
    constraint fk_order_user foreign key(user_id)
    references tbl_user(id),
    constraint fk_order_product foreign key(product_id)
    references tbl_product(id)
);

/*
    1. 요구사항 분석
        꽃 테이블과 화분 테이블 2개가 필요하고,
        꽃을 구매할 때 화분도 같이 구매합니다.
        꽃은 이름과 색상, 가격이 있고,
        화분은 제품번호, 색상, 모양이 있습니다.
        화분은 모든 꽃을 담을 수 없고 정해진 꽃을 담아야 합니다.

    2. 개념 모델링
        꽃               화분
        -------------------------------------
        번호              꽃번호
        -------------------------------------
        이름              제품번호
        색상              색상
        가격              모양

    3. 논리 모델링
        꽃               화분
        -------------------------------------
        번호PK            꽃번호FK, PK
        -------------------------------------
        이름NN, U         제품번호NN U
        색상NN            색상NN
        가격D=0           모양NN

    4. 물리 모델링
        tbl_flower                              tbl_flower_pot
        --------------------------------------------------------------
        id bigint primary key                   flower_id bigint primary key
        --------------------------------------------------------------
        name varchar(255) not null unique       number varchar(255) not null unique
        color varchar(255) not null             color varchar(255) not null
        price int default 0                     constraint fk_pot_flower foreign key(flower_id)
                                                references tbl_flower(id)

    5. 구현
*/

create table tbl_flower(
    id bigint primary key,
    name varchar(255) not null,
    color varchar(255) not null,
    price int default 0
);

create table tbl_pot(
    flower_id bigint primary key,
    number varchar(255) not null,
    color varchar(255) not null,
    shape varchar(255) default 'circle',
    constraint fk_pot_flower foreign key(flower_id)
    references tbl_flower(id)
);

create table tbl_pot(
    id bigint primary key,
    color varchar(255) not null,
    shape varchar(255) not null,
    flower_id bigint not null,
    constraint fk_pot_flower foreign key(flower_id)
    references tbl_flower(id)
);


/*
    복합키(조합키): 하나의 PK에 여러 컬럼을 설정한다.
*/
create table tbl_flower(
    name varchar(255) not null,
    color varchar(255) not null,
    price int default 0,
    primary key(name, color)
);

create table tbl_pot(
    id bigint primary key,
    number varchar(255) not null,
    color varchar(255) not null,
    shape varchar(255) default 'circle',
    flower_name varchar(255) not null,
    flower_color varchar(255) not null,
    constraint fk_pot_flower foreign key(flower_name, flower_color)
    references tbl_flower(name, color)
);

drop table tbl_flower;

drop table tbl_pot;

/*
    1. 요구사항 분석
        안녕하세요, 동물변원을 곧 개원합니다.
        동물은 보호자랑 항상 같이 옵니다. 가끔 보호소에서 오는 동물도 있습니다.
        보호자가 여러 마리의 동물을 데리고 올 수 있습니다.
        보호자는 이름, 나이, 전화번호, 주소가 필요하고
        동물은 병명, 이름, 나이, 몸무게가 필요합니다.

    2. 개념 모델링
        보호자         동물
        --------------------
        번호          번호
        --------------------
        이름          이름
        나이          병명
        전화번호       나이
        주소          몸무게
                      보호자 번호

    3. 논리 모델링
        보호자         동물
        --------------------
        번호pk        번호pk
        --------------------
        이름nn        이름nn
        나이          병명nn
        전화번호nn     나이nn
        주소nn        몸무게nn
                      보호자 번호nn fk

    4. 물리 모델링
        tbl_member                      tbl_animal
        ------------------------------------------------------------
        id bigint primary key           id bigint primary key
        ------------------------------------------------------------
        name varchar(255) not null      name varchar(255) not null
        age int                         disease varchar(255) not null
        phone varchar(255) not null     age int not null
        address varchar(255) not null   weight decimal(3, 2)
                                        member_id bigint not null
                                        constraint fk_animal_member foreign key(member_id)
                                        references tbl_member(id)

    5. 구현
*/
create table tbl_member(
    id bigint primary key,
    name varchar(255) not null,
    age int default 0,
    phone varchar(255) not null,
    address varchar(255) not null
);

create table tbl_animal(
    id bigint primary key,
    name varchar(255) default '사랑',
    ill_name varchar(255) not null,
    age int default 0,
    weight decimal(3, 2) default 0.0,
    member_id bigint,
    constraint fk_animal_member foreign key(member_id)
    references tbl_member(id)
);

drop table tbl_animal;
drop table tbl_member;

show tables;

/*
    1. 요구사항 분석
        안녕하세요, 중고차 딜러입니다.
        이번에 자동차와 차주를 관리하고자 방문했습니다.
        자동차는 여러 명의 차주로 히스토리에 남아야 하고,
        차주는 여러 대의 자동차를 소유할 수 있습니다.
        그래서 우리는 항상 등록증(Registration)을 작성합니다.
        자동차는 브랜드. 모델명, 가격, 출시 날짜가 필요하고
        차주는 이름, 전화번호, 주소가 필요합니다.

    2. 개념 모델링
        자동차         차주          등록증Registration
        ----------------------------------
        번호           번호          번호
        ----------------------------------
        브랜드         이름          차량번호
        모델명         전화번호       차주번호
        가격           주소
        출시 날짜


    3. 논리 모델링
        자동차         차주                  등록증Registration
        ----------------------------------
        번호pk         번호pk               번호pk
        ----------------------------------
        브랜드nn         이름nn             차량번호fk, nn
        모델명nn         전화번호nn, u         차주번호fk, nn
        가격d=0          주소nn
        출시 날짜d=ct

    4. 물리 모델링
        tbl_car                                 tbl_owner                               tbl_registration
        -------------------------------------------------------------------------------------------------------
        id bigint primary key                   id bigint primary key                   id bigint primary key
        -------------------------------------------------------------------------------------------------------
        brand varchar(255) not null             name varchar(255) not null              car_id bigint not null,
        model varchar(255) not null             phone varchar(255) not null unique      owner_id bigint not null,
        price int not null default 0            address varchar(255) not null           constraint fk_registration_car foreign key(car_id)
        launch_date date default current_date                                           references tbl_car(id)
                                                                                        constraint fk_registration_owner foreign key(owner_id)
                                                                                        references tbl_owner(id)

    5. 구현
*/

create table tbl_car(
    id bigint primary key,
    brand varchar(255) not null,
    model varchar(255) not null,
    price bigint default 0,
    launch_date date default (current_date)
);

create table tbl_owner(
    id bigint primary key,
    name varchar(255) not null,
    phone varchar(255) not null unique,
    address varchar(255) not null
);

create table tbl_registration(
    id bigint primary key,
    car_id bigint not null,
    owner_id bigint not null,
    constraint fk_registration_car foreign key(car_id)
    references tbl_car(id),
    constraint fk_registration_owner foreign key(owner_id)
    references tbl_owner(id)
);

drop table tbl_registration;
drop table tbl_car;
drop table tbl_owner;


/*
    요구 사항
    커뮤니티 게시판을 만들고 싶어요.
    게시판에는 게시글 제목과 게시글 내용, 작성한 시간, 작성자가 있고,
    게시글에는 댓글이 있어서 댓글 내용들이 나와야 해요.
    작성자는 회원(TBL_USER)정보를 그대로 사용해요.
    댓글에도 작성자가 필요해요.

    2. 개념 모델링
        작성자     게시글          댓글
        ----------------------------------
        번호       번호           번호
        ----------------------------------
        아이디     게시글 제목      작성자 번호
        비밀번호    게시글 내용     게시글 번호
        이름       작성한 시간      댓글 내용
        주소       작성자 번호
        이메일     댓글 번호
        생일

    3. 논리 모델링
        작성자     게시글          댓글
        ----------------------------------
        번호pk     번호pk         번호pk
        ----------------------------------
        아이디nn     게시글 제목nn         작성자 번호fk
        비밀번호nn, u    게시글 내용nn     게시글 번호fk
        이름nn       작성한 시간d=ct      댓글 내용nn
        주소nn       작성자 번호fk
        이메일
        생일

    4. 물리 모델링
        tbl_car                                 tbl_owner                               tbl_registration
        -------------------------------------------------------------------------------------------------------
        id bigint primary key                   id bigint primary key                   id bigint primary key
        -------------------------------------------------------------------------------------------------------
        brand varchar(255) not null             name varchar(255) not null              car_id bigint not null,
        model varchar(255) not null             phone varchar(255) not null unique      owner_id bigint not null,
        price int not null default 0            address varchar(255) not null           constraint fk_registration_car foreign key(car_id)
        launch_date date default current_date                                           references tbl_car(id)
                                                                                        constraint fk_registration_owner foreign key(owner_id)
                                                                                        references tbl_owner(id)

    5. 구현
*/

create table tbl_user(
    id bigint primary key,
    user_id varchar(255) not null unique,
    password varchar(255) not null,
    name varchar(255) not null,
    address varchar(255) not null,
    email varchar(255),
    birth date
);

create table tbl_post(
    id bigint primary key,
    post_title varchar(255) not null,
    post_content varchar(255) not null,
    write_time datetime default (current_timestamp),
    user_id bigint not null,
    constraint fk_post_user foreign key(user_id)
                     references tbl_user(id)
);

create table reply(
    id bigint primary key,
    reply_content varchar(255) not null,
    user_id bigint not null,
    post_id bigint not null,
    constraint fk_reply_user foreign key(user_id)
                     references tbl_user(id),
    constraint fk_reply_post foreign key(post_id)
                     references tbl_post(id)
);
drop table reply;
drop table tbl_post;
drop table tbl_user;

/*
    요구사항

    마이페이지에서 회원 프로필을 구현하고 싶습니다.
    회원당 프로필을 여러 개 설정할 수 있고,
    대표 이미지로 선택된 프로필만 화면에 보여주고 싶습니다.

    2. 개념 모델링
        회원      프로필
        -------------------
        번호      번호
        -------------------
        아이디
        비밀번호
    3. 논리 모델링
    4. 물리 모델링
    5. 구현
*/

create table tbl_user(
    id bigint primary key,
    user_id varchar(255) not null unique,
    password varchar(255) not null,
    name varchar(255) not null,
    address varchar(255) not null,
    email varchar(255),
    birth date
);

create table tbl_user_profile(
    id bigint primary key,
    file_path varchar(255) default '/upload',
    file_name varchar(255),
    is_main varchar(255) default 'ELSE',
    user_id bigint,
    constraint fk_user_profile_user foreign key(user_id)
                     references tbl_user(id)
);

drop table tbl_user_profile;
drop table tbl_user;

/*
    요구사항

    학사 관리 시스템에 학생과 교수, 과목을 관리합니다.
    학생은 학번, 이름, 전공 학년이 필요하고
    교수는 교수 번호, 이름, 전공, 직위가 필요합니다.
    과목은 고유한 과목 번호와 과목명, 학점이 필요합니다.
    학생은 여러 과목을 수강할 수 있으며,
    교수는 여러 과목을 강의할 수 있습니다.
    학생이 수강한 과목은 성적이 모두 기록됩니다.

    2. 개념 모델링
    3. 논리 모델링
    4. 물리 모델링
    5. 구현
*/

create table tbl_student(
    id bigint primary key,
    name varchar(255)not null,
    major varchar(255)not null,
    grade int default 1
);

create table tbl_professor(
    id bigint primary key,
    name varchar(255)not null,
    major varchar(255)not null,
    position varchar(255)not null
);

/*
직접 professor의 id를 받아오는 것보다는 중간 테이블을 이용하는 것이 좋다
  1. 불필요한 데이터의 삽입이상
    만약 과목은 정해졌지만 담당교수님이 정해지지 않았을 경우 professor_id가
    불필요한 값이 되기 때문이다.

  2. 교수와 과목은 N : N 관계이기 때문에 중간테이블이 필요하다.
    모델링 시 교수와 과목을 1 : N 관계로 생각하고 작성했다.
    하지만 한명의 교수가 여러개의 과목을 담당할 수 있고, 하나의 과목을
    여러명의 교수가 진행할 수 있기 때문이다.

강사님 코드
create table tbl_subject(
        id bigint auto_increment primary key,
        name varchar(255) not null,
        score int default 0
    );
*/
create table tbl_subject(
    id bigint primary key,
    name varchar(255)not null unique,
    credit int default 0.0,
    professor_id bigint not null,
    constraint fk_subject_professor foreign key(professor_id)
                        references tbl_professor(id)
);

create table tbl_study_subject(
    id bigint primary key,
    grade int default 0,
    student_id bigint not null,
    subject_id bigint not null,
    constraint fk_study_subject_student foreign key(student_id)
                        references tbl_student(id),
    constraint fk_study_subject_subject foreign key(subject_id)
                        references tbl_subject(id)
);

/*
    요구사항

    대카테고리, 소카테고리가 필요해요.

    2. 개념 모델링
    3. 논리 모델링
    4. 물리 모델링
    5. 구현
*/

create table tbl_category_a(
    id bigint primary key,
    category_name varchar(255) not null
);

create table tbl_category_b(
    id bigint primary key,
    category_name varchar(255) not null,
    category_a_id bigint not null,
    constraint fk_category_b_category_a foreign key(category_a_id)
                           references tbl_category_a(id)
);

/*
    요구 사항

    회의실 예약 서비스를 제작하고 싶습니다.
    회원별로 등급이 존재하고 사무실마다 회의실이 여러 개 있습니다.
    회의실 이용 가능 시간은 파트 타임으로서 여러 시간대가 존재합니다.

    2. 개념 모델링
    3. 논리 모델링
    4. 물리 모델링
    5. 구현
*/

create table tbl_member(
    id bigint primary key,
    name varchar(255) not null,
    address varchar(255) not null,
    phone varchar(255) not null,
    user_rank varchar(255) default '일반회원'
);

create table tbl_office(
    id bigint primary key,
    name varchar(255) not null unique,
    address varchar(255) not null unique
);

create table tbl_conference_room(
    id bigint primary key,
    number int not null unique,
    office_id bigint not null unique,
    constraint fk_conference_room_office foreign key(office_id)
                                references tbl_office(id)
);

create table tbl_part_time(
    id bigint primary key,
    time datetime not null,
    conference_room_id bigint not null,
    constraint fk_part_time_conference_room foreign key(conference_room_id)
                          references tbl_conference_room(id)
);

create table tbl_reservation(
    id bigint primary key,
    start_time datetime not null,
    end_time datetime not null,
    member_id bigint not null,
    conference_room_id bigint not null,
    constraint fk_reservation_member foreign key(member_id)
                            references tbl_member(id),
    constraint fk_reservation_conference_room foreign key(conference_room_id)
                            references tbl_conference_room(id)
);

/*
    요구사항

    유치원을 하려고 하는데, 아이들이 체험학습 프로그램을 신청해야 합니다.
    아이들 정보는 이름, 나이, 성별이 필요하고 학부모는 이름, 나이, 주소, 전화번호, 성별이 필요해요
    체험학습은 체험학습 제목, 체험학습 내용, 이벤트 이미지 여러 장이 필요합니다.
    아이들은 여러 번 체험학습에 등록할 수 있어요.

    2. 개념 모델링
    3. 논리 모델링
    4. 물리 모델링
    5. 구현
*/

create table tbl_parent(
    id bigint primary key,
    name varchar(255) not null,
    age int default 0,
    address varchar(255) not null,
    phone varchar(255) not null,
    gender varchar(255) check ( gender in ('남성', '여성'))
);

create table tbl_child(
    id bigint primary key,
    name varchar(255) not null,
    age int default 0,
    gender varchar(255) check ( gender in ('남성', '여성')),
    parent_id bigint not null,
    constraint fk_child_parent foreign key(parent_id)
                      references tbl_parent(id)
);

create table tbl_field_trip(
    id bigint primary key,
    title varchar(255) not null unique,
    content varchar(255) not null unique
);

create table tbl_event_picture(
    id bigint primary key,
    file_path varchar(255) default '/update/',
    file_name varchar(255) not null,
    field_trip_id bigint not null,
    constraint fk_event_picture_field_trip foreign key(field_trip_id)
                              references tbl_field_trip(id)
);

create table tbl_apply(
    id bigint primary key,
    child_id bigint not null,
    field_trip_id bigint not null,
    constraint fk_apply_child foreign key(child_id)
                      references tbl_child(id),
    constraint fk_apply_field_trip foreign key(field_trip_id)
                      references tbl_field_trip(id)
);

/*
    요구사항

    안녕하세요, 광고 회사를 운영하려고 준비중인 사업가입니다.
    광고주는 기업이고 기업 정보는 이름, 주소, 대표번호, 기업종류(스타트업, 중소기업, 중견기업, 대기업)입니다.
    광고는 제목, 내용이 있고 기업은 여러 광고를 신청할 수 있습니다.
    기업이 광고를 선택할 때에는 카테고리로 선택하며, 대카테고리, 중카테고리, 소카테고리가 있습니다.

    2. 개념 모델링
    3. 논리 모델링
    4. 물리 모델링
    5. 구현
*/

create table tbl_company(
    id bigint primary key,
    name varchar(255) not null,
    address varchar(255) not null,
    company_number varchar(255) not null,
    company_type varchar(255) not null check (company_type in ('스타트업', '중소기업', '중견기업', '대기업') )
);

create table tbl_category_a(
    id bigint primary key,
    name varchar(255) not null
);

create table tbl_category_b(
    id bigint primary key,
    name varchar(255) not null,
    category_a_id bigint not null,
    constraint fk_category_b_category_a foreign key(category_a_id)
                           references tbl_category_a(id)
);

create table tbl_category_c(
    id bigint primary key,
    name varchar(255) not null,
    category_b_id bigint not null,
    constraint fk_category_c_category_b foreign key(category_b_id)
                           references tbl_category_b(id)
);

create table tbl_advertisement(
    id bigint primary key,
    title varchar(255) not null,
    content varchar(255) not null,
    category_c_id bigint not null,
    constraint fk_advertisement_category_c foreign key(category_c_id)
                              references tbl_category_c(id)
);

create table tbl_commission(
    id bigint primary key,
    company_id bigint not null,
    advertisement_id bigint not null,
    constraint fk_commission_company foreign key(company_id)
                              references tbl_company(id),
    constraint fk_commission_advertisement foreign key(advertisement_id)
                              references tbl_advertisement(id)
);

drop table tbl_advertisement;

/*
    요구사항

    음료수 판매 업체입니다. 음료수마다 당첨번호가 있습니다.
    음료수의 당첨번호는 1개이고 당첨자의 정보를 알아야 상품을 배송할 수 있습니다.
    당첨 번호마다 당첨 상품이 있고, 당첨 상품이 배송 중인지 배송 완료인지 구분해야 합니다.

    2. 개념 모델링
    3. 논리 모델링
    4. 물리 모델링
    5. 구현
*/

create table tbl_person(
    id bigint primary key,
    user_id varchar(255) not null unique,
    password varchar(255) not null,
    name varchar(255) not null,
    address varchar(255) not null,
    phone varchar(255) not null,
    email varchar(255)
);

create table tbl_drink(
    id bigint primary key,
    name varchar(255) not null,
    price int default 0
);

create table tbl_prize(
    id bigint primary key,
    name varchar(255) not null,
    price int default 0
);

create table tbl_lottery_number(
    id bigint primary key,
    prize_id bigint not null,
    constraint fk_lottery_number_prize foreign key(prize_id)
                               references tbl_prize(id)
);

create table tbl_winning(
    id bigint primary key,
    drink_id bigint not null,
    lottery_number_id bigint not null unique,
    constraint fk_winning_drink foreign key(drink_id)
                        references tbl_drink(id),
    constraint fk_winning_lottery_number foreign key(lottery_number_id)
                        references tbl_lottery_number(id)
);

create table tbl_deliver(
    id bigint primary key,
    deliver_status varchar(255) check ( deliver_status in ('배송 중','배송 완료') ),
    person_id bigint not null,
    prize_id bigint not null,
    constraint fk_deliver_person foreign key(person_id)
                        references tbl_person(id),
    constraint fk_deliver_prize foreign key(prize_id)
                        references tbl_prize(id)
);

/*
    요구사항

    이커머스 창업 준비중입니다. 기업과 사용자 간 거래를 위해 기업의 정보와 사용자 정보가 필요합니다.
    기업의 정보는 기업 이름, 주소, 대표번호가 있고
    사용자 정보는 이름, 주소, 전화번호가 있습니다. 결제 시 사용자 정보와 기업의 정보, 결제한 카드의 정보 모두 필요하며,
    상품의 정보도 필요합니다. 상품의 정보는 이름, 가격, 재고입니다.
    사용자는 등록한 카드의 정보를 저장할 수 있으며, 카드의 정보는 카드번호, 카드사, 회원 정보가 필요합니다.

    2. 개념 모델링
    3. 논리 모델링
    4. 물리 모델링
    5. 구현
*/

create table tbl_buyer(
    id bigint primary key,
    name varchar(255) not null,
    address varchar(255) not null,
    phone varchar(255) not null
);

create table tbl_corporation(
    id bigint primary key,
    name varchar(255) not null,
    address varchar(255) not null,
    corporation_number  varchar(255) not null
);

create table tbl_credit_card(
    id bigint primary key,
    company varchar(255) not null,
    buyer_id bigint not null,
    constraint fk_credit_card_buyer foreign key(buyer_id)
                            references tbl_buyer(id)
);

create table tbl_product(
    id bigint primary key,
    name varchar(255) not null,
    price int default 0,
    stoke int default 0,
    corporation_id bigint not null,
    constraint fk_product_corporation foreign key(corporation_id)
                        references tbl_corporation(id)
);

create table tbl_order(
    id bigint primary key,
    buyer_id bigint not null,
    company_id bigint not null,
    constraint fk_credit_buyer foreign key(buyer_id)
                            references tbl_buyer(id),
    constraint fk_credit_card_company foreign key(company_id)
                            references tbl_company(id)
);

create table tbl_payment(
    id bigint primary key,
    credit_card_id bigint not null,
    order_id bigint not null,
    constraint fk_payment_credit_card foreign key(credit_card_id)
                        references tbl_credit_card(id),
    constraint fk_payment_order foreign key(order_id)
                        references tbl_order(id)
);

drop table tbl_payment;