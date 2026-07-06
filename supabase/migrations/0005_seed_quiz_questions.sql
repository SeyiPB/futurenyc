-- =============================================================================
-- Migration 0005: real per-day quiz questions from the FutureNYC curriculum
-- =============================================================================
-- 5 retention questions for each of the 20 daily quizzes, grounded in each
-- day's Learning Objectives and Key Takeaway.
--
-- Function-free / dollar-quote-free for maximum SQL-runner compatibility.
-- Every statement is self-contained and ends in a single semicolon.
-- Idempotent: clears existing day-quiz questions first, then reseeds.
-- =============================================================================

-- Clear existing questions on every program-day quiz (cascades to options/answers).
delete from public.quiz_questions
where quiz_id in (select id from public.quizzes where day_id is not null);

-- Give each day's quiz a curriculum-aligned title.
update public.quizzes q set title = sub.t
from (
  select pd.id as day_id, 'Day ' || pd.day_number || ' Review: ' || pd.title as t
  from public.program_days pd
) sub
where q.day_id = sub.day_id;


-- ===================== WEEK 1: AI FLUENCY & FOUNDATIONS =====================

-- Day 1
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 1, 'At a conceptual level, how does a large language model (LLM) produce a response?', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 1) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'It predicts the next word (token) one at a time based on patterns it learned', true),
      (2, 'It searches a database for the saved answer', false),
      (3, 'It copies the most-viewed web page on the topic', false),
      (4, 'It asks a human expert in real time', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 2, 'Which everyday tool is the best analogy for how an LLM works?', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 1) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Your phone keyboard''s autocomplete', true),
      (2, 'A calculator', false),
      (3, 'A library card catalog', false),
      (4, 'A search engine''s list of links', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 3, 'Roughly what is a "token" to an LLM?', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 1) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'About three-quarters of a word, on average', true),
      (2, 'Exactly one sentence', false),
      (3, 'A single letter, always', false),
      (4, 'One full paragraph', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 4, 'Because an LLM predicts probable text, which statement is TRUE?', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 1) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'It can be confidently wrong because it generates what is probable, not what is verified', true),
      (2, 'It always tells the truth', false),
      (3, 'It remembers every past conversation forever by default', false),
      (4, 'It knows about events that happened after its training cutoff', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 5, 'Claude, ChatGPT, and Gemini are best described as…', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 1) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Different tools from different companies with different strengths and blind spots', true),
      (2, 'Exactly the same product with different names', false),
      (3, 'Search engines that only return links', false),
      (4, 'Human-staffed help desks', false)
) as v(pos, label, correct);

-- Day 2
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 1, 'What are the four elements of a strong prompt?', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 2) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Role, Task, Constraints, Examples', true),
      (2, 'Greeting, Question, Thanks, Goodbye', false),
      (3, 'Topic, Length, Font, Color', false),
      (4, 'Who, What, When, Where', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 2, 'Why does a vague prompt like "help me write an essay" give mediocre results?', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 2) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'The AI doesn''t know what you want, so it guesses toward a generic, average answer', true),
      (2, 'The AI refuses to answer vague prompts', false),
      (3, 'The AI runs out of tokens immediately', false),
      (4, 'Short prompts are against the rules', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 3, 'In a prompt, what does giving the AI a "Role" actually do?', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 2) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Activates the right vocabulary, framing, and depth for your need', true),
      (2, 'Changes the underlying AI model to a smarter one', false),
      (3, 'Connects the AI to the internet', false),
      (4, 'Makes the response longer no matter what', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 4, 'Which of these is an actual "Task" (not a vague request)?', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 2) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, '"Give me 5 alternative opening lines for this email"', true),
      (2, '"Help me"', false),
      (3, '"Do something with this"', false),
      (4, '"Make it good"', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 5, 'The best summary of what prompting really is:', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 2) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Giving the AI enough information to do its job well', true),
      (2, 'Knowing the secret magic words', false),
      (3, 'Typing as few words as possible', false),
      (4, 'Using all capital letters', false)
) as v(pos, label, correct);

-- Day 3
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 1, 'Where does AI bias mainly come from?', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 3) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Patterns and imbalances in the data the model was trained on', true),
      (2, 'A bias setting engineers forgot to turn off', false),
      (3, 'The user''s own typing speed', false),
      (4, 'Random chance with no cause', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 2, 'What is an AI "hallucination"?', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 3) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'When the AI generates confident, plausible-sounding information that is false', true),
      (2, 'When the AI refuses to answer', false),
      (3, 'When the AI shows you its sources', false),
      (4, 'When the AI translates a language', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 3, 'Who is responsible for using AI output responsibly?', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 3) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'You — the model doesn''t know when it''s wrong, biased, or harmful', true),
      (2, 'The AI model itself', false),
      (3, 'No one, since it''s automated', false),
      (4, 'The internet', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 4, 'Anthropic trains Claude using an approach called…', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 3) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Constitutional AI — the model critiques its own output against explicit principles', true),
      (2, 'Rule-based filtering only', false),
      (3, 'Random sampling', false),
      (4, 'No safety training at all', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 5, 'A core camp ground rule about AI and privacy is:', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 3) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Never enter real personal data (address, school ID, passwords) into any AI', true),
      (2, 'Always paste your home address for better answers', false),
      (3, 'Share your passwords so the AI can help', false),
      (4, 'Personal data makes the AI more accurate, so use it', false)
) as v(pos, label, correct);

-- Day 4
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 1, 'What is the "Trust But Verify" framework for AI research?', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 4) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Use AI to orient and speed up research, but confirm claims against real sources', true),
      (2, 'Trust the AI completely and never check', false),
      (3, 'Never use AI for research at all', false),
      (4, 'Only verify if the answer feels wrong', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 2, 'A key limitation of AI as a research tool is that it…', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 4) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Cannot verify itself and will sometimes be confidently wrong', true),
      (2, 'Can never be useful for research', false),
      (3, 'Always cites perfect sources automatically', false),
      (4, 'Only works on math problems', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 3, 'Which is a PRIMARY source?', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 4) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'The original study, document, or first-hand record itself', true),
      (2, 'A news article summarizing a study', false),
      (3, 'An AI-generated summary', false),
      (4, 'A friend''s opinion about the topic', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 4, 'The verification skill practiced on Day 4 is best described as:', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 4) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Find the claim, find the source, check the claim', true),
      (2, 'Copy the answer and move on', false),
      (3, 'Ask the AI if it''s sure', false),
      (4, 'Pick whichever answer is longest', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 5, 'Good AI-assisted synthesis means…', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 4) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Combining your own verified sources into a clear, supported summary', true),
      (2, 'Letting the AI invent sources for you', false),
      (3, 'Avoiding all sources and guessing', false),
      (4, 'Only using one source ever', false)
) as v(pos, label, correct);

-- Day 5
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 1, 'What is the Week 1 mini-project deliverable?', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 5) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'A Personal AI Use Guide plus a verified research artifact', true),
      (2, 'A finished video game', false),
      (3, 'A fully automated Zap', false),
      (4, 'A cloned voiceover', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 2, 'Your Personal AI Use Guide should be based on…', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 5) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Your own experimentation, failure, discovery, and reflection from the week', true),
      (2, 'A template copied from the internet', false),
      (3, 'Whatever the AI tells you to write', false),
      (4, 'A single example from Day 1', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 3, 'When stating an AI tool preference, you should back it with…', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 5) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Specific, evidence-based reasoning from your own testing', true),
      (2, 'Whichever tool is most popular online', false),
      (3, 'A coin flip', false),
      (4, 'The tool with the nicest logo', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 4, 'Why will your personal AI framework stay useful as tools change?', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 5) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Because you know HOW to update it through testing and reflection', true),
      (2, 'Because AI tools never change', false),
      (3, 'Because the guide is permanent and fixed', false),
      (4, 'Because the facilitator will rewrite it for you', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 5, 'A strong research artifact for presentation is one that is…', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 5) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Built from verified sources you checked yourself', true),
      (2, 'Entirely AI-generated with no checking', false),
      (3, 'Copied from a classmate', false),
      (4, 'Made of unverified claims', false)
) as v(pos, label, correct);

-- ===================== WEEK 2: AI MEDIA & STORYTELLING =====================

-- Day 6
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 1, 'How should you treat story structure when creating with AI?', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 6) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'As a foundation to build on, not a formula to fill in mechanically', true),
      (2, 'As strict rules you can never break', false),
      (3, 'As something to ignore completely', false),
      (4, 'As a replacement for any creative idea', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 2, 'What is the creative brief you write on Day 6 for?', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 6) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'It is your creative "constitution" guiding every prompt for the week', true),
      (2, 'It is graded homework with no further use', false),
      (3, 'It is the final video itself', false),
      (4, 'It is a list of AI tools to install', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 3, 'Why generate and compare story concepts across three AI platforms?', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 6) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Different tools surface different ideas, so you can choose the strongest', true),
      (2, 'It is required to use all three for legal reasons', false),
      (3, 'Only one tool can write stories', false),
      (4, 'To make the project take longer', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 4, 'Every prompt you write this week should…', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 6) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Serve the creative brief you wrote', true),
      (2, 'Ignore the brief and improvise', false),
      (3, 'Be identical to the last one', false),
      (4, 'Avoid mentioning your story', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 5, 'A creative brief mainly captures…', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 6) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Your story concept, direction, and intent', true),
      (2, 'Your account passwords', false),
      (3, 'The AI''s training data', false),
      (4, 'A list of unrelated facts', false)
) as v(pos, label, correct);

-- Day 7
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 1, 'What makes an effective AI image prompt?', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 7) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Specifics like lighting, style, mood, and composition', true),
      (2, 'A single vague word like "cool"', false),
      (3, 'Only the color you want', false),
      (4, 'As little detail as possible', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 2, 'How should you treat your first image generation?', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 7) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'As a draft to iterate on, not a finished product', true),
      (2, 'As the final image you must keep', false),
      (3, 'As proof the prompt failed', false),
      (4, 'As something to delete immediately', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 3, 'Specificity in an image prompt translates into…', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 7) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Precision in the output', true),
      (2, 'A slower computer', false),
      (3, 'A random unrelated image', false),
      (4, 'Fewer options to choose from', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 4, 'What is the goal of developing a "visual series"?', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 7) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'A set of images with a consistent style', true),
      (2, 'One image repeated many times', false),
      (3, 'Images in totally different unrelated styles', false),
      (4, 'Text with no images', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 5, 'Iteration in image generation is a sign that…', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 7) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'You''re refining a draft toward your vision', true),
      (2, 'You did something wrong', false),
      (3, 'The tool is broken', false),
      (4, 'You should give up', false)
) as v(pos, label, correct);

-- Day 8
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 1, 'Which tool is used to generate a voiceover (text-to-speech)?', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 8) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'ElevenLabs', true),
      (2, 'Suno', false),
      (3, 'Zapier', false),
      (4, 'Veo', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 2, 'Which tool is used to generate or select music?', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 8) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Suno', true),
      (2, 'ElevenLabs', false),
      (3, 'Pika', false),
      (4, 'Google Forms', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 3, 'Which tools are used to produce a short AI video clip?', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 8) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Google Veo 3.1 or Pika', true),
      (2, 'ElevenLabs or Suno', false),
      (3, 'Zapier or Sheets', false),
      (4, 'Claude or Gemini text', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 4, 'What ethical issue is central to AI audio/video tools?', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 8) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Voice cloning and synthetic media — using someone''s likeness without consent', true),
      (2, 'Choosing the right font', false),
      (3, 'How fast the file downloads', false),
      (4, 'Picking a thumbnail color', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 5, 'After Day 8 you have the three production layers in draft form:', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 8) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Visual, audio, and motion', true),
      (2, 'Code, data, and forms', false),
      (3, 'Email, calendar, and chat', false),
      (4, 'Intro, body, and conclusion', false)
) as v(pos, label, correct);

-- Day 9
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 1, 'In AI-assisted creation, what is the human creator''s core job?', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 9) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Curation, editing, and judgment — deciding which options serve the story', true),
      (2, 'Generating as many files as possible', false),
      (3, 'Letting the AI make every decision', false),
      (4, 'Avoiding any editing', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 2, 'Where does the story "actually live"?', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 9) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'In the edit', true),
      (2, 'In the first raw clip', false),
      (3, 'In the file name', false),
      (4, 'In the tool''s settings', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 3, 'Editing principles applied to your rough cut include…', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 9) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Pacing, clarity, and emotional arc', true),
      (2, 'Font size and margins', false),
      (3, 'Upload speed and file type', false),
      (4, 'Number of accounts used', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 4, 'What is the purpose of a creative statement + AI attribution?', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 9) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'To honestly explain your process and credit AI tools you used', true),
      (2, 'To hide that you used AI', false),
      (3, 'To list your passwords', false),
      (4, 'To replace the project entirely', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 5, 'Structured peer critique is used to…', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 9) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Identify gaps so you can make targeted improvements', true),
      (2, 'Rank students against each other', false),
      (3, 'Decide who gets to use the AI', false),
      (4, 'Avoid changing anything', false)
) as v(pos, label, correct);

-- Day 10
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 1, 'The emphasis in "AI-assisted creator" is on which word?', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 10) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Creator — you brought the vision, judgment, and editing', true),
      (2, 'Assisted — the AI did the real work', false),
      (3, 'AI — the tool gets the credit', false),
      (4, 'None of these', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 2, 'When presenting, you should be able to articulate…', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 10) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Your creative process, tool use, and design decisions', true),
      (2, 'Only the final result with no explanation', false),
      (3, 'The AI''s training data', false),
      (4, 'Your classmates'' passwords', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 3, 'In an AI-assisted piece, what did the human bring that the AI did not?', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 10) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Vision, judgment, specificity, and editing', true),
      (2, 'Raw generation speed', false),
      (3, 'Unlimited file storage', false),
      (4, 'The ability to predict tokens', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 4, 'Giving and receiving structured feedback on creative work helps you…', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 10) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'See your work clearly and improve it', true),
      (2, 'Win points by criticizing others', false),
      (3, 'Avoid ever changing your piece', false),
      (4, 'Skip the presentation', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 5, 'The big idea of Week 2 is that human + AI together…', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 10) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Made something neither could have made alone', true),
      (2, 'Proved AI should do everything', false),
      (3, 'Showed humans are no longer needed', false),
      (4, 'Means creativity no longer matters', false)
) as v(pos, label, correct);

-- ===================== WEEK 3: AUTOMATION, APPS & AI AGENTS =====================

-- Day 11
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 1, 'What is the basic pattern underlying all automation?', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 11) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Trigger → Action', true),
      (2, 'Question → Answer', false),
      (3, 'Input → Delete', false),
      (4, 'Start → Stop', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 2, 'A "trigger" in an automation is…', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 11) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'The event that starts the automation', true),
      (2, 'The final result', false),
      (3, 'An error message', false),
      (4, 'The person who built it', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 3, 'How does a traditional automation differ from an AI agent?', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 11) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Traditional automation follows fixed rules; an AI agent can handle inputs no rule anticipated', true),
      (2, 'They are exactly the same', false),
      (3, 'AI agents can only send emails', false),
      (4, 'Traditional automation is always smarter', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 4, 'Which tool does the camp use to build automations?', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 11) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Zapier', true),
      (2, 'ElevenLabs', false),
      (3, 'Suno', false),
      (4, 'Pika', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 5, 'The "intelligence" of an automation depends on…', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 11) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'What you build into each step', true),
      (2, 'How fast your internet is', false),
      (3, 'The color of the interface', false),
      (4, 'How many accounts you have', false)
) as v(pos, label, correct);

-- Day 12
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 1, 'What is "field mapping" in Zapier?', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 12) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Telling each step which data from a previous step to use', true),
      (2, 'Drawing a map of your office', false),
      (3, 'Changing the app''s theme', false),
      (4, 'Deleting old Zaps', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 2, 'When a Zap breaks, the error message usually…', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 12) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Tells you where the logic failed so you can fix it', true),
      (2, 'Means the Zap can never be fixed', false),
      (3, 'Is safe to ignore', false),
      (4, 'Deletes your account', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 3, 'A working Zap, when it runs successfully, …', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 12) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Works silently in the background — that''s the point', true),
      (2, 'Sends you a popup every second', false),
      (3, 'Requires you to run it by hand each time', false),
      (4, 'Shows an error even when correct', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 4, '"Automation is logic made visible" means…', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 12) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Each step is an explicit piece of logic you can see and debug', true),
      (2, 'Automation is magic with no rules', false),
      (3, 'You can''t tell what a Zap does', false),
      (4, 'Logic doesn''t matter in automation', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 5, 'A basic Zap is built from…', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 12) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'A trigger plus one or more action steps', true),
      (2, 'Only a title', false),
      (3, 'A single password', false),
      (4, 'Three videos', false)
) as v(pos, label, correct);

-- Day 13
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 1, 'What do you add to a Zap to make it AI-powered?', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 13) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'An AI action step', true),
      (2, 'A second trigger', false),
      (3, 'A new email account', false),
      (4, 'A video clip', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 2, 'How do you make an AI prompt inside a Zap "dynamic"?', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 13) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Insert Zapier variable fields so it uses real data from earlier steps', true),
      (2, 'Type the same fixed text every time', false),
      (3, 'Leave the prompt blank', false),
      (4, 'Use only emojis', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 3, 'How is AI-powered automation different from rule-based automation?', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 13) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'It can handle inputs no rule-writer anticipated', true),
      (2, 'It is always cheaper', false),
      (3, 'It never makes mistakes', false),
      (4, 'It cannot use variables', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 4, 'Because an AI step can be wrong, you must design…', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 13) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'A safeguard for what happens when the AI is wrong, not just when it''s right', true),
      (2, 'A faster internet connection', false),
      (3, 'A prettier interface', false),
      (4, 'More trigger events', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 5, 'The flexibility of AI automation comes with…', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 13) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'A design responsibility to plan for errors', true),
      (2, 'A guarantee of perfect output', false),
      (3, 'No downsides at all', false),
      (4, 'Fewer steps automatically', false)
) as v(pos, label, correct);

-- Day 14
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 1, 'What is a "structured output" from an AI?', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 14) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'A response in a consistent, parseable format an automation can use', true),
      (2, 'A long unformatted paragraph', false),
      (3, 'A random list each time', false),
      (4, 'An image file', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 2, 'The full automation pipeline you assemble is…', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 14) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Form + AI analysis + structured output + safeguard', true),
      (2, 'Video + music + voiceover', false),
      (3, 'Role + Task + Constraints + Examples', false),
      (4, 'Trigger only', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 3, 'Why does form design matter for automation?', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 14) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Good automation starts with good, structured data from a well-designed form', true),
      (2, 'Forms have nothing to do with automation', false),
      (3, 'Forms only affect colors', false),
      (4, 'Forms slow everything down', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 4, 'A gap anywhere in the data chain shows up as…', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 14) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'A failure when the automation runs in the real world', true),
      (2, 'A bonus feature', false),
      (3, 'Faster performance', false),
      (4, 'Nothing at all', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 5, 'Why think about data privacy in automated workflows?', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 14) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Automated systems move real people''s data, so it must be handled responsibly', true),
      (2, 'Privacy only matters for images', false),
      (3, 'Automations never touch real data', false),
      (4, 'Privacy is the AI''s job, not yours', false)
) as v(pos, label, correct);

-- Day 15
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 1, 'What did your Week 3 automation accomplish?', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 15) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'It does real work without you — a professional capability', true),
      (2, 'It only printed "hello"', false),
      (3, 'It generated a video', false),
      (4, 'It cloned a voice', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 2, 'When presenting your automation, you should explain…', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 15) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'The problem it addresses and the design decisions behind it', true),
      (2, 'Only that it exists', false),
      (3, 'Your account password', false),
      (4, 'The AI''s training data', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 3, 'The automation architecture you learned is used…', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 15) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'By real companies and organizations around the world', true),
      (2, 'Only in this camp', false),
      (3, 'Nowhere outside of games', false),
      (4, 'Only by AI researchers', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 4, 'The reusable automation pattern is…', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 15) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Form + AI analysis + structured output + safeguard', true),
      (2, 'Trigger with no action', false),
      (3, 'A single AI chat message', false),
      (4, 'A video edit timeline', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 5, 'A safeguard in an automation exists to…', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 15) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Handle cases where the AI or data is wrong', true),
      (2, 'Make the Zap run faster', false),
      (3, 'Add more colors', false),
      (4, 'Replace the trigger', false)
) as v(pos, label, correct);

-- ===================== WEEK 4: CAPSTONE STUDIO =====================

-- Day 16
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 1, 'What was the most important thing to do when choosing a capstone?', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 16) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Scope it honestly so it''s achievable in the time you have', true),
      (2, 'Make it as big and ambitious as possible', false),
      (3, 'Copy a classmate''s idea', false),
      (4, 'Pick the flashiest idea regardless of scope', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 2, 'Most projects fail because…', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 16) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'The scope was unrealistic, not because the idea was bad', true),
      (2, 'The idea was too simple', false),
      (3, 'They used AI tools', false),
      (4, 'They were finished too early', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 3, 'What is an "MVP" in the context of your capstone?', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 16) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'A minimum viable product — the core version you can actually build', true),
      (2, 'The most valuable person', false),
      (3, 'A marketing video plan', false),
      (4, 'A maximum version with every feature', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 4, 'Your one-page project brief should include…', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 16) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'A defined MVP scope and a day-by-day build plan', true),
      (2, 'Only a title', false),
      (3, 'A list of unrelated ideas', false),
      (4, 'Your passwords', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 5, 'A skills inventory helps you…', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 16) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'See what you''ve built in Weeks 1–3 to inform your capstone', true),
      (2, 'Rank students by talent', false),
      (3, 'Decide who wins prizes', false),
      (4, 'Avoid building anything', false)
) as v(pos, label, correct);

-- Day 17
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 1, 'What professional build-day discipline structures Day 17?', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 17) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Stand-up, task list, focus, check-out', true),
      (2, 'Sleep, snack, scroll, leave', false),
      (3, 'Only a final presentation', false),
      (4, 'Random free time', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 2, 'A morning "stand-up" is…', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 17) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'A short meeting to state your goals/plan for the day', true),
      (2, 'A physical exercise break', false),
      (3, 'A final demo', false),
      (4, 'A grading session', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 3, 'Why address your highest-risk assumption early?', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 17) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'If it''s wrong, you want to find out while there''s still time to adjust', true),
      (2, 'It''s the easiest task', false),
      (3, 'It impresses the audience', false),
      (4, 'Risk doesn''t matter', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 4, 'A good Day 17 outcome is…', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 17) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Your first major tangible asset or working component', true),
      (2, 'A finished, polished final project', false),
      (3, 'Nothing yet — just planning', false),
      (4, 'A new project idea to start over', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 5, 'You should end the day with…', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 17) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Clear, specific goals for Day 18', true),
      (2, 'No plan for tomorrow', false),
      (3, 'A request to change projects', false),
      (4, 'A deleted project', false)
) as v(pos, label, correct);

-- Day 18
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 1, 'What does "integration" mean for your project?', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 18) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Getting all major components working together as one coherent whole', true),
      (2, 'Starting a brand-new project', false),
      (3, 'Deleting half your work', false),
      (4, 'Adding as many new features as possible', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 2, 'Why is integration often the hardest part?', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 18) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'It''s when everything that doesn''t fit together becomes visible', true),
      (2, 'It''s the easiest, most relaxing step', false),
      (3, 'Nothing ever goes wrong in integration', false),
      (4, 'It requires no testing', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 3, 'A good end-of-Day-18 state is a project that…', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 18) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Can be tested by someone other than yourself', true),
      (2, 'Only you understand', false),
      (3, 'Has no working parts', false),
      (4, 'Was just started', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 4, 'Mid-day facilitator feedback should be…', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 18) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Acted on to improve the project', true),
      (2, 'Ignored to save time', false),
      (3, 'Argued with on principle', false),
      (4, 'Saved for after Demo Day', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 5, 'Day 18 moves you from…', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 18) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Individual parts to a demo-able whole', true),
      (2, 'A whole back to scattered parts', false),
      (3, 'Idea to brand-new idea', false),
      (4, 'Finished to unfinished', false)
) as v(pos, label, correct);

-- Day 19
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 1, 'What is a "feature freeze"?', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 19) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Stopping new features so you can test, fix, and rehearse what you have', true),
      (2, 'Adding as many features as possible at the end', false),
      (3, 'Deleting all features', false),
      (4, 'Freezing your laptop', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 2, 'Why is rehearsal called the most important part of presenting?', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 19) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Practiced presenters know what to say and show, and stay relaxed', true),
      (2, 'It impresses no one', false),
      (3, 'It replaces building the project', false),
      (4, 'It''s only for shy people', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 3, 'How many times should you rehearse your full Demo Day talk?', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 19) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'At least twice', true),
      (2, 'Zero — just wing it', false),
      (3, 'Once is plenty', false),
      (4, 'Only in your head', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 4, '"Stress-testing" your project means…', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 19) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Getting peers/facilitators to try it and surface problems', true),
      (2, 'Making it look pretty', false),
      (3, 'Hiding the bugs', false),
      (4, 'Adding more code', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 5, 'The students who present best tomorrow are usually…', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 19) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'The ones who rehearsed enough to be confident', true),
      (2, 'The ones with the most features', false),
      (3, 'The ones who skipped practice', false),
      (4, 'The ones who built the biggest project', false)
) as v(pos, label, correct);

-- Day 20
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 1, 'What is Demo Day?', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 20) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Presenting your capstone to an external audience in a professional setting', true),
      (2, 'A normal build day', false),
      (3, 'A written exam', false),
      (4, 'A day off', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 2, 'During Demo Day you also…', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 20) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Give and receive specific, substantive feedback on each other''s work', true),
      (2, 'Only watch silently', false),
      (3, 'Start a new project', false),
      (4, 'Avoid talking to anyone', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 3, 'Across four weeks you built which portfolio pieces?', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 20) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'An AI media piece, an automation, and a capstone project', true),
      (2, 'Only a certificate', false),
      (3, 'Only a quiz score', false),
      (4, 'Nothing tangible', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 4, 'A professional demo presentation should clearly show…', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 20) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'The problem, your solution, and how it works', true),
      (2, 'Only your name', false),
      (3, 'Unrelated jokes only', false),
      (4, 'Your passwords', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 5, 'The biggest takeaway of the program is that you can…', 'mc', 20 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 20) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Direct AI to create, build, and present real work — you''re a creator, not just a user', true),
      (2, 'Only open a chatbot and type', false),
      (3, 'Never use AI again', false),
      (4, 'Rely on AI to do all thinking for you', false)
) as v(pos, label, correct);
