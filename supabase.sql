-- 영어 질문 코치: 학생 시도 기록 테이블
-- Supabase → SQL Editor 에 붙여 넣고 Run 을 누르세요.

create table if not exists public.attempts (
  id          bigint generated always as identity primary key,
  created_at  timestamptz not null default now(),
  level       smallint    not null check (level between 0 and 2),
  words       text        not null check (char_length(words) <= 300),
  sentence    text        not null check (char_length(sentence) <= 300),
  score       smallint    not null check (score between 0 and 100)
);

-- 보안 핵심 1: RLS(행 수준 보안)를 켭니다.
alter table public.attempts enable row level security;

-- 보안 핵심 2: 정책(policy)을 하나도 만들지 않습니다.
-- → 브라우저용 publishable(anon) 키로는 읽기·쓰기 모두 불가.
-- → 서버 함수의 secret 키만 저장할 수 있고, 선생님은 대시보드 Table Editor 에서 봅니다.
revoke all on table public.attempts from anon, authenticated;

-- 점검용: 아래 결과의 rowsecurity 가 true 여야 합니다.
select tablename, rowsecurity from pg_tables where schemaname = 'public' and tablename = 'attempts';
