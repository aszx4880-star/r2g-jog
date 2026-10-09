#!/usr/bin/env bash
# R2G Jog 실행. 먼저 ROS 2 와 두산 드라이버 메시지(dsr_msgs2)를 source 한 터미널에서.
# 예: ./run.sh --rg2-ip 192.168.1.1
cd "$(dirname "$0")" && exec python3 -m ready2go_skills.nodes.jog_gui "$@"
