# R2G Jog — 두산 M0609 + OnRobot RG2 조그·교시 창

9기 ready2go 팀(@9기_SDG)이 실물 로봇 교시·측정용으로 쓰는 Tkinter 조그 창입니다.
교시 도구일 뿐 작업 실행 코드가 아닙니다. **처음에는 로봇 주변을 비우고 느린 속도로 써 보세요.**

## 먼저 바꿀 것 (지금은 우리 팀 값)
| 무엇 | 어디 | 우리 값 |
| :--- | :--- | :--- |
| 펜던트 TCP 이름·툴(무게) 이름 | `config/calibration/calibration_meta.yaml` | `GripperDA_v1` / `tool_weight` |
| gohome 관절각 | `config/poses.yaml` | `[0, 0, 90, 0, 90, 0]` |
| RG2 IP | 실행 인자 `--rg2-ip` 또는 환경변수 `RG2_HOST` | `192.168.1.1` |
| 드라이버 서비스 접두어 | 실행 인자 `--srv` | `/dsr01/dsr_controller2` |
| 좌표로 이동(posj) 관절 제한 | `ready2go_skills/nodes/jog_gui.py` 의 `J5_MAX, J3_MIN` | J5 ≤ 133°, J3 ≥ 10° (우리 셀 기준) |
| ROS 도메인·DDS | 각자 터미널 환경 (`ROS_DOMAIN_ID`, `CYCLONEDDS_URI`) | 70, lo 전용 설정 |

- 펜던트의 TCP·툴 이름이 yaml 과 다르면 창 위에 빨간 띠가 뜨고 이동 버튼이 막힙니다. 펜던트를 고치거나 yaml 을 고치세요.
- RG2 IP를 안 주면 그리퍼 칸만 "RG2 IP 없음"으로 뜨고 나머지는 동작합니다.

## 필요한 것
- ROS 2 Jazzy, 두산 ROS 2 드라이버(`dsr_msgs2`)가 실행 중이고 그 워크스페이스를 source 한 터미널
- `sudo apt install python3-tk python3-yaml` / `pip install pymodbus`
- 그리퍼: OnRobot Compute Box 에 Modbus TCP(포트 502, unit 65)로 직접 붙음 (로봇 컨트롤러 거치지 않음)

## 실행
```bash
source /opt/ros/jazzy/setup.bash
source <두산 드라이버 워크스페이스>/install/setup.bash
git clone https://github.com/aszx4880-star/r2g-jog.git && cd r2g-jog
./run.sh --rg2-ip 192.168.1.1          # 또는 python3 -m ready2go_skills.nodes.jog_gui --rg2-ip ...
```
`config/` 는 이 폴더 안 것을 자동으로 찾습니다. 다른 곳이면 `--config-dir <경로>` 또는 환경변수 `READY2GO_CONFIG_DIR`.

매번 치기 귀찮으면 `~/.bashrc` 에 alias 한 줄 (clone 위치·IP·source 경로는 자기 것으로):
```bash
alias r2gjog='source /opt/ros/jazzy/setup.bash && source <두산 드라이버 워크스페이스>/install/setup.bash && ~/r2g-jog/run.sh --rg2-ip 192.168.1.1'
```

## 화면
- **위**: 툴 상태 띠 · 툴 힘(reset 시점 대비 변화, 화면 표시만) · 꾹 누르기 속도(2–20 %) · posx/posj 지금 값(copy = 그 줄 복사, 둘 다 copy = posx·posj 두 줄 한 번에)
- **관절 이동 / 직선 이동(base_link 기준)**: −/+ 는 로봇의 *지금* 위치에서 증분만큼. 꾹 누르면 연속 조그(손 떼면 정지, 최대 5초).
  입력칸을 고치면 노란색 → "입력값으로 movej/movel" 목표. "지금 값" = 고친 칸 취소.
- **좌표로 이동**: `posx([...])` → movel, `posj([...])` → movej, 숫자만이면 물어봄. 이동 전 확인창. Ctrl+A 전체 선택.
- **그리퍼 기울이기 / 정렬·회전**: TCP 위치 고정, 돌기 전 확인창. 정렬이 끝나면 직접교시가 켜짐.
- **그리퍼**: 닫기(힘) · 최대 열기 · 폭만큼 열기 · 직접교시 ON/OFF · gohome(확인창)
- **정지**: 빨간 버튼 · Esc · Space(입력칸에 커서가 없을 때). 결과(제어기 수락/거부/응답 없음)가 아래 상태줄과 터미널에 뜸.
- **비상정지 해제**: 소프트웨어 안전정지(충돌·한계)만, 확인창 뒤. 물리 비상정지 버튼은 직접 풀어야 하고, 안전정지2·서보 꺼짐2는 펜던트에서 복구.

## 주의
- 실물 로봇에서 쓰는 도구입니다. 움직이기 전에 경로에 부딪힐 것이 없는지 직접 확인하세요.
- 같은 로봇에 다른 프로그램이 동시에 명령을 보내지 않게 하세요.
- 출처: 저장소 `Jik-Kim/ready2go` `ros2_ws/src/ready2go_skills` (10/09 기준, ecba10e), 강의 rokey_cobot2 jog 화면을 바탕으로 수정.
