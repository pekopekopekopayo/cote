## 문제

1. 고객은 예약 신청이 가능한 시간과 인원을 알 수 있습니다.
- 일반조회

2. 예약은 시험 시작 3일 전까지 신청 가능하며, 동 시간대에 최대 5만명까지 예약할 수 있습니다. 이때, 확정되지 않은 예약은 5만명의 제한에 포함되지 않습니다.
  예를 들어, 4월 15일 14시부터 16시까지 이미 3만 명의 예약이 확정되어 있을 경우, 예상 응시 인원이 2만명 이하인 추가 예약 신청이 가능합니다.

- 규모에 따라서 5만명을 전부 SQL COUNT하여도 무관하지만 저는 booked_count라는 컬럼에 + 1을 하는 형식이 부하가 더 적을 것이라고 생각하여 그렇게 구현하였습니다.
  또한 동시성문제가 일어날 가능성이 존재하므로 Lock을 걸어 동시성문제를 해결해였습니다

- 문제에서 두가지가 충돌하는 듯한 느낌을 받았습니다.
  `1. 확정 받지않은 예약은 5만명에 제한에 포함하지않는다` 그리고
  `2. 3만 명의 예약이 확정되어 있을 경우, 예상 응시 인원이 2만명 이하인 추가 예약 신청이 가능합니다.`
  한곳에서는 제한을 하지않는다.
  한곳에서는 제한을 한다.
  라고 이해를 하였습니다.
  `1` 에 대한 내용이라면 예약신청은 자유로 확정은 5만명
  `2` 에 대한 내용이라면 예약신청 + 확정 = 5만명으로 보입니다.
  다른 문제에서도 `확정되지 않은 예약은 최대 인원 수 계산에 포함되지 않습니다.`라고 적혀있었으므로 저는 `1`번 사양이 맞다고 생각하고 작업에 임하였습니다.

3. 예약에는 시험 일정과 응시 인원이 포함되어야 합니다.
- start_at, booked_count를 활용하므로 조회는 느리지 않을 것으로 예상

4. 예약 확정: 고객의 예약 신청 후, 어드민이 이를 확인하고 확정을 통해 예약이 최종적으로 시험 운영 일정에 반영됩니다. 확정되지 않은 예약은 최대 인원 수 계산에 포
함되지 않습니다.
- Lock을 걸어서 booked_count에 + 1을 하는 형식으로 진행하였습니다.

5. 고객은 예약 확정 전에 본인 예약을 수정할 수 있습니다. | 고객은 확정 전에 본인 예약을 삭제할 수 있습니다.
- 고객이 예약확정전에 수정을 할 수 있다고 적혀있지만 수정을 할 수 있다라는 행동자체는 예약 취소밖에 없다고 생각이 들었으므로 예약 취소를 가능하게 만들었습니다.

6. 어드민은 모든 고객의 예약을 확정할 수 있습니다.
- 어드민 API모듈 자체를 나누어서 관리를 하였습니다. before_action으로 어드민이 아닐경우에는 해당 컨트롤러에 진입을 할 수 없습니다.

7. 어드민은 고객 예약을 수정할 수 있습니다. | 어드민은 모든 고객의 예약을 삭제할 수 있습니다.
- 예약의 수정에 관하여 상세내용이 없어 무엇을 수정이 가능하게 만들어야하는지 상세 내용이 없어 무엇을 수정을 하게 해야하는지 이해를 하지 못하였습니다. 제가 생각하기로는 예약을 취소 또는 예약을 확정하는 기능으로 생각을 하였으므로 해당 기능을 추가하였습니다.


## 작성된 코드를 로컬 환경에서 실행해보기 위한 환경 설정 및 실행 방법
1. docker compose up -d 또는 docker compose up
2. localhost 3000 번으로 접근

## API DOC

1. GET users
  desc '유저 생성'
  param name, desc '이름'
  returns :200

2. GET customer/:current_user_id/exams
  desc '모든 시험을 조회'
  returns :200
  ```
  [
    {
      id:
      name:
      start_at:
      booked_count:
      created_at:
      updated_at:
    }
  ]
  ```

3. GET customer/:current_user_id/exam_schedules
  desc '자신의 모든 스케줄 보기'
  param :page, :number
  returns :200
  ```
  [
    {
      id:
      name:
      start_at:
      booked_count:
      created_at:
      updated_at:
    }
  ]
  ```
4. POST customer/:current_user_id/exam_schedules
  desc '예약'
  param exam_id, :number
  returns :200

5. DELETE customer/:current_user_id/exam_schedules
  desc '예약취소'
  returns :200

6. GET admin/:current_user_id/exams
  desc '어드민 모든시험보기(중복)'
  returns :200
  ```
  [
    {
      id:
      name:
      start_at:
      booked_count:
      created_at:
      updated_at:
    }
  ]
  ```
7. POST admin/:current_user_id/exams
  desc '어드민 시험만들기'
  param :start_at(과거시간에 관하여 딱히 막지않음)
  param :name
  returns :200

8. GET admin/:current_user_id/exam_schedules
  desc '모든 사용자 일정보기'
  param :page :number
  returns :200
  ```
  [
    {
      id:
      user_id:
      exam_id:
      created_at:
      updated_at:
    }
  ]
  ```
9. POST admin/:current_user_id/exam_schedules/:id/approve
  desc '예약 확정'
  returns :200

10. POST admin/:current_user_id/exam_schedules/:id/reject
  desc '예약 취소'
  returns :200
