# Workflow Generalization Plan

## 배경 (Background)

- `/auto` PDCA 워크플로우(SKILL.md 515줄 + REFERENCE.md 1741줄)에 도메인 특화 요소가 기본 워크플로우에 포함되어 있음
- --mockup 상세 워크플로우(55줄), Vercel BP 규칙(47개), Playwright 하드코딩, Rule 10 이미지 분석(76줄), .omc/ 경로 잔재가 범용화를 저해
- 이 리팩토링은 기존 기능 동작에 영향 없이 구조만 정리하는 순수 리팩토링

## 구현 범위 (Scope)

### 포함 항목
- 제안 1: SKILL.md Step 3.0 --mockup 상세를 mockup-hybrid 스킬로 이동
- 제안 2: REFERENCE.md Vercel BP 규칙을 별도 참조 파일로 추출
- 제안 3: SKILL.md E2E 프레임워크 감지를 다중 프레임워크로 추상화
- 제안 4: Rule 10 이미지 분석을 스킬 가이드라인으로 이동
- 제안 5: .omc/ 경로를 .claude/context/로 교체

### 제외 항목
- 워크플로우 로직 변경 (순수 구조 정리만)
- 새로운 기능 추가
- PRD 생성 (리팩토링이므로 --skip-prd 적용)
- E2E 테스트 (--skip-e2e 적용)
- 이슈 생성 (--no-issue 적용)

## 영향 파일 (Affected Files)

### 수정 예정 파일

| # | 파일 (절대 경로) | 제안 | 변경 내용 |
|---|------------------|------|-----------|
| 1 | `C:\claude\.claude\skills\auto\SKILL.md` | 1,3 | Step 3.0 --mockup 상세 제거 → 라우팅 테이블만 유지 (228-283줄), 금지 사항 mockup 특화 항목 이동 (513-515줄), E2E 감지 추상화 (389줄) |
| 2 | `C:\claude\.claude\skills\auto\REFERENCE.md` | 1,2,5 | --slack 워크플로우 .omc/ 경로 교체 (1559줄), --gmail 워크플로우 .omc/ 경로 교체 (1604줄), Vercel BP 규칙 추출 (1413-1453줄), E2E runner prompt Playwright 하드코딩 제거 (397줄) |
| 3 | `C:\claude\.claude\skills\mockup-hybrid\SKILL.md` | 1 | --mockup 실행 경로 상세 (SKILL.md에서 이동한 내용) 추가 — 캡처/문서 삽입 워크플로우 |
| 4 | `C:\claude\.claude\rules\10-image-analysis.md` | 4 | 파일 삭제 (내용을 가이드라인으로 이동) |

### 신규 생성 파일

| # | 파일 (절대 경로) | 제안 | 설명 |
|---|------------------|------|------|
| 5 | `C:\claude\.claude\references\vercel-bp-rules.md` | 2 | Vercel BP 47개 규칙 독립 파일 |
| 6 | `C:\claude\.claude\skills\auto\guidelines\image-analysis.md` | 4 | 이미지 분석 가이드라인 (Rule 10에서 이동) |

### 디렉토리 생성

| # | 경로 | 제안 | 설명 |
|---|------|------|------|
| 7 | `C:\claude\.claude\skills\auto\guidelines\` | 4 | 스킬별 가이드라인 디렉토리 (현재 미존재) |
| 8 | `C:\claude\.claude\context\slack\` | 5 | Slack 컨텍스트 저장소 (.omc/ 대체) |
| 9 | `C:\claude\.claude\context\gmail\` | 5 | Gmail 컨텍스트 저장소 (.omc/ 대체) |

## 태스크 목록 (Tasks)

### Task 1: .omc/ 경로 정리 [제안 5 — IMMEDIATE]

**설명**: REFERENCE.md 내 .omc/ 잔재를 .claude/context/로 교체

**수행 방법**:
1. `C:\claude\.claude\context\slack\` 디렉토리 생성
2. `C:\claude\.claude\context\gmail\` 디렉토리 생성
3. `REFERENCE.md` 1559줄: `.omc/slack-context/<채널ID>.md` → `.claude/context/slack/<채널ID>.md`
4. `REFERENCE.md` 1604줄: `.omc/gmail-context/<timestamp>.md` → `.claude/context/gmail/<timestamp>.md`
5. 전체 REFERENCE.md에서 `.omc/` 패턴 grep → 추가 잔재 있으면 동일 처리

**Acceptance Criteria**:
- REFERENCE.md 내 `.omc/` 문자열 0건
- `.claude/context/slack/` 및 `.claude/context/gmail/` 디렉토리 존재
- --slack, --gmail 워크플로우 흐름에 논리적 변경 없음 (경로만 교체)

---

### Task 2: Vercel BP 규칙 추출 [제안 2 — MEDIUM]

**설명**: REFERENCE.md의 Vercel BP 47개 규칙을 독립 참조 파일로 추출

**수행 방법**:
1. `C:\claude\.claude\references\vercel-bp-rules.md` 생성
2. REFERENCE.md 1417-1448줄 (```=== Vercel Best Practices 검증 규칙 ===``` 블록 전체) 이동
3. REFERENCE.md 해당 위치에 참조 포인터 삽입:
   ```
   ## Vercel BP 검증 규칙

   Phase 4 Step 4.2에서 code-reviewer teammate prompt에 동적 주입하는 규칙:

   > 상세: `.claude/references/vercel-bp-rules.md`
   ```
4. 동적 주입 조건 (1450-1452줄)은 REFERENCE.md에 그대로 유지:
   ```
   **동적 주입 조건:**
   - `Glob("next.config.*")` 결과 존재 또는 `package.json` 내 `"react"` dependency 존재 시 주입
   - 웹 프로젝트가 아닌 경우 생략
   ```

**Acceptance Criteria**:
- `C:\claude\.claude\references\vercel-bp-rules.md` 파일에 47개 규칙 전체 포함
- REFERENCE.md에서 규칙 코드 블록 제거, 참조 포인터만 존재
- REFERENCE.md에 동적 주입 조건 유지
- 기존 `.claude/references/` 디렉토리 내 8개 파일과 공존

---

### Task 3: SKILL.md Step 3.0 --mockup 상세 이동 [제안 1 — HIGH]

**설명**: SKILL.md의 --mockup 실행 경로 상세(228-283줄)를 mockup-hybrid 스킬로 이동하고, SKILL.md에는 라우팅 테이블만 유지

**수행 방법**:

**3-A: SKILL.md 정리** (228-283줄 대체)
- 현재 228-283줄의 `--mockup 실행 경로`, `Step 3.0.2 PNG 캡처`, `Step 3.0.3 문서 삽입` 전체를 제거
- 대체 텍스트:
  ```
  **--mockup 실행 경로**: mockup-hybrid 스킬 참조 (`.claude/skills/mockup-hybrid/SKILL.md`)
  - 파일 지정: 문서 내 ASCII 다이어그램 감지 → Mermaid/HTML 자동 변환
  - 화면명 지정: designer teammate → HTML 생성 → PNG 캡처 → 문서 삽입
  - 상세 워크플로우 (캡처, 문서 삽입, 폴백): mockup-hybrid SKILL.md 참조
  ```

**3-B: SKILL.md 금지 사항 정리** (513-515줄)
- `executor가 docs/mockups/*.html 직접 생성 금지` — mockup-hybrid SKILL.md로 이동
- SKILL.md 금지 사항에는 참조만 남기기: `**mockup 관련 금지 사항**: mockup-hybrid SKILL.md 참조`

**3-C: mockup-hybrid SKILL.md 보강**
- `C:\claude\.claude\skills\mockup-hybrid\SKILL.md` 말미에 `/auto 연동` 섹션 추가:
  - Step 3.0.2 PNG 캡처 코드 블록 (SKILL.md 251-265줄 내용)
  - Step 3.0.3 문서 삽입 규칙 (SKILL.md 267-279줄 내용)
  - 금지 사항: executor가 docs/mockups/*.html 직접 생성 금지

**3-D: REFERENCE.md --slack, --gmail 워크플로우 정리**
- --slack (1531-1563줄): 이미 독립 섹션이므로 구조 유지. `.omc/` 경로만 Task 1에서 수정 완료
- --gmail (1566-1614줄): 동일. `.omc/` 경로만 Task 1에서 수정 완료
- 추가 이동 불필요 (이미 REFERENCE.md의 옵션 워크플로우 섹션으로 분리되어 있음)

**Acceptance Criteria**:
- SKILL.md Step 3.0 영역에 --mockup 상세 코드 블록 0건 (라우팅 포인터만 존재)
- mockup-hybrid SKILL.md에 `/auto 연동` 섹션 존재 (캡처, 삽입, 금지 사항 포함)
- SKILL.md 총 줄 수: 기존 515줄 → 약 470줄 (약 45줄 감소)

---

### Task 4: E2E 프레임워크 추상화 [제안 3 — LOW]

**설명**: Playwright 하드코딩을 다중 프레임워크 감지로 교체

**수행 방법**:

**4-A: SKILL.md 389줄 수정**
- Before:
  ```python
  and Glob("playwright.config.{ts,js}")         # Playwright 설정 존재
  ```
- After:
  ```python
  and (                                          # E2E 프레임워크 설정 존재
      Glob("playwright.config.{ts,js}")
      or Glob("cypress.config.{ts,js}")
      or Glob("vitest.config.{ts,js}")           # browser mode
  )
  ```

**4-B: REFERENCE.md E2E runner prompt (397-400줄 부근) 수정**
- Before:
  ```
  prompt="[Phase 4 E2E Background]
         Playwright E2E 테스트 백그라운드 실행.
         1. npx playwright test --reporter=list 실행
  ```
- After:
  ```
  prompt="[Phase 4 E2E Background]
         E2E 테스트 백그라운드 실행.
         1. 프레임워크 감지:
            - playwright.config.* → npx playwright test --reporter=list
            - cypress.config.* → npx cypress run --reporter spec
            - vitest.config.* (browser) → npx vitest run --reporter verbose
         2. 감지된 프레임워크로 실행
  ```

**Acceptance Criteria**:
- SKILL.md E2E 감지 조건에 3개 프레임워크 패턴 포함
- REFERENCE.md E2E runner prompt에 프레임워크 분기 로직 존재
- 기존 Playwright 프로젝트에서 동작 변경 없음 (첫 번째 매칭이 Playwright)

---

### Task 5: Rule 10 이미지 분석 분리 [제안 4 — LOW]

**설명**: `.claude/rules/10-image-analysis.md`를 스킬 가이드라인으로 이동하여 모든 세션 자동 로드에서 제외

**수행 방법**:

**5-A: 가이드라인 디렉토리 생성**
- `C:\claude\.claude\skills\auto\guidelines\` 디렉토리 생성

**5-B: 파일 이동**
- `C:\claude\.claude\rules\10-image-analysis.md` 내용을 `C:\claude\.claude\skills\auto\guidelines\image-analysis.md`로 복사
- 원본 파일 삭제

**5-C: 참조 업데이트**
- SKILL.md에서 `10-image-analysis.md` 참조가 있는지 확인 → 경로 업데이트
- `.claude/rules/` 에 `10-image-analysis.md` 언급하는 다른 파일 확인 → 경로 업데이트
- 영향 파일 목록:
  - `C:\claude\.claude\rules\08-skill-routing.md` — 참조 가능성
  - `C:\claude\.claude\skills\auto\SKILL.md` 224줄 — `11-ascii-diagram.md` 기준 타입 판별 (10번 규칙 직접 참조 없음)
  - `C:\Users\AidenKim\.claude\projects\C--claude\memory\MEMORY.md` — 규칙 테이블 업데이트

**5-D: .claude/rules/ 디렉토리 관리**
- 규칙 번호 갭(9→11)은 유지 (재넘버링 불필요 — 번호 변경 시 연쇄 참조 깨짐 위험)

**Acceptance Criteria**:
- `.claude/rules/10-image-analysis.md` 파일 미존재
- `.claude/skills/auto/guidelines/image-analysis.md` 파일 존재 (내용 동일)
- 이미지 분석 키워드 트리거 시 해당 가이드라인이 스킬 컨텍스트로 로드됨
- 비-이미지 분석 세션에서 자동 로드되지 않음
- 코드베이스 내 `10-image-analysis.md` 참조 0건

---

### Task 6: 교차 검증 및 일관성 확인

**설명**: 모든 변경사항의 교차 참조 정합성 검증

**수행 방법**:
1. 전체 코드베이스에서 `.omc/` 패턴 grep → 0건 확인
2. SKILL.md ↔ REFERENCE.md 간 참조 정합성 확인
3. mockup-hybrid SKILL.md ↔ auto SKILL.md 간 중복 제거 확인
4. `.claude/references/` 디렉토리에 `vercel-bp-rules.md` 존재 확인
5. `.claude/rules/` 디렉토리에 `10-image-analysis.md` 미존재 확인
6. MEMORY.md 규칙 테이블 업데이트 (Rule 10 경로 변경 반영)

**Acceptance Criteria**:
- 코드베이스 내 `.omc/` 참조 0건
- 삭제된 파일에 대한 참조 0건
- 모든 참조 포인터가 유효한 파일을 가리킴

## 위험 요소 (Risks)

### Risk 1: 참조 깨짐 (HIGH)
- **설명**: Rule 10 파일 이동 시 해당 파일을 참조하는 다른 규칙/문서의 경로가 깨질 수 있음
- **완화**: Task 5-C에서 코드베이스 전체 grep으로 `10-image-analysis` 패턴 검색 후 모두 업데이트. Task 6에서 교차 검증
- **Edge Case**: `.claude/settings.json`이나 Hook 설정에서 rules 디렉토리를 glob으로 로드하는 경우 — 파일 삭제 시 자동으로 로드 대상에서 제외됨 (안전)

### Risk 2: mockup-hybrid SKILL.md 중복 (MEDIUM)
- **설명**: SKILL.md에서 이동한 캡처/삽입 워크플로우가 mockup-hybrid SKILL.md 기존 내용과 의미적으로 중복될 수 있음
- **완화**: mockup-hybrid SKILL.md를 읽고 기존 내용과 이동 내용의 범위를 명확히 구분. 기존 = 3-Tier 라우팅/생성, 추가 = /auto 연동(캡처+삽입+폴백)
- **Edge Case**: mockup-hybrid 스킬이 /auto 없이 독립 실행될 때 캡처/삽입 섹션이 혼란을 줄 수 있음 — `/auto 연동` 섹션 헤더로 명확히 분리

### Risk 3: Vercel BP 동적 주입 실패 (LOW)
- **설명**: REFERENCE.md에서 규칙 블록을 추출한 후, code-reviewer prompt 동적 주입 시 참조 파일을 Read해야 하는 추가 단계가 필요
- **완화**: REFERENCE.md에 동적 주입 조건과 함께 "주입 시 `.claude/references/vercel-bp-rules.md` 내용을 Read하여 prompt에 포함" 지시를 명시
- **Edge Case**: code-reviewer 에이전트가 참조 파일 경로를 인식하지 못하는 경우 — prompt에 절대 경로 명시

### Risk 4: E2E 다중 프레임워크 감지 우선순위 충돌 (LOW)
- **설명**: 프로젝트에 playwright.config.ts와 cypress.config.ts가 동시에 존재하는 경우 어느 프레임워크를 실행할지 모호
- **완화**: or 연산자의 short-circuit 특성으로 첫 번째 매칭(Playwright) 우선. E2E runner prompt에도 "첫 번째 감지된 프레임워크 사용" 명시

### Risk 5: .claude/context/ 디렉토리 권한/gitignore (LOW)
- **설명**: 새 디렉토리가 git 추적 대상이 되거나 .gitignore에 의해 차단될 수 있음
- **완화**: `.claude/context/` 디렉토리에 `.gitkeep` 파일 생성. `.gitignore` 확인하여 `.claude/` 하위가 차단되지 않는지 검증

## 커밋 전략 (Commit Strategy)

순서대로 커밋. 각 커밋은 독립적으로 동작 가능해야 함.

| 순서 | 커밋 메시지 | 태스크 | 변경 파일 |
|:----:|------------|:------:|-----------|
| 1 | `refactor(auto): .omc/ 경로를 .claude/context/로 교체` | Task 1 | REFERENCE.md, 디렉토리 생성 |
| 2 | `refactor(auto): Vercel BP 규칙을 references/로 추출` | Task 2 | REFERENCE.md, vercel-bp-rules.md |
| 3 | `refactor(auto): --mockup 상세를 mockup-hybrid 스킬로 이동` | Task 3 | SKILL.md, mockup-hybrid/SKILL.md |
| 4 | `refactor(auto): E2E 프레임워크 감지 추상화` | Task 4 | SKILL.md, REFERENCE.md |
| 5 | `refactor(rules): Rule 10 이미지 분석을 스킬 가이드라인으로 이동` | Task 5 | rules/10-image-analysis.md 삭제, guidelines/image-analysis.md 생성 |
| 6 | `refactor(auto): 교차 참조 정합성 검증 완료` | Task 6 | 잔여 참조 수정 (있는 경우만) |

## 구현 순서 (Execution Order)

```
  Task 1 (.omc/ 정리)
       |
       v
  Task 2 (Vercel BP 추출) ----+---- Task 3 (--mockup 이동)
       |                       |
       v                       v
  Task 4 (E2E 추상화)    Task 5 (Rule 10 분리)
       |                       |
       +----------+------------+
                  |
                  v
           Task 6 (교차 검증)
```

- Task 1은 선행 필수 (Task 2-5에서 REFERENCE.md 수정 시 충돌 방지)
- Task 2, 3은 병렬 가능 (수정 영역 비중복: REFERENCE.md 1413-1453 vs SKILL.md 228-283)
- Task 4, 5는 병렬 가능 (수정 파일 비중복: SKILL.md 389줄 vs rules/ 파일)
- Task 6은 모든 태스크 완료 후 실행
