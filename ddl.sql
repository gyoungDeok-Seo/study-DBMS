# 전체 데이터베이스 조회
show databases;

# test 데이터베이스 사용
use test;

# 회원 테이블 생성
create table tbl_member(
    member_name varchar(255),
    member_age int,
    member_address varchar(255)
);

# 현재 database에 생성된 테이블 전체 조회
show tables;

# 테이블 삭제
drop table tbl_member;

/*
    자동차 테이블 생성
    1. 자동차 번호
    2. 자동차 브랜드
    3. 출시 날짜
    4. 색상
    5. 가격
*/
create table tbl_car(
    number bigint primary key,
    brand varchar(255),
    release_date date,
    color varchar(255),
    price int
);

show tables;

drop table tbl_car;

/*
    동물 테이블 생성
    1. 번호
    2. 종류
    3. 먹이
*/
create table tbl_animal(
    number bigint primary key,
    type varchar(255) not null unique,
    feed varchar(255)
);

show tables;

drop table tbl_animal;