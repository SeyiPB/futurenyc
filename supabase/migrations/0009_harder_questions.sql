-- =============================================================================
-- Migration 0009: harder quiz questions for Days 2-20 (8 per day)
-- =============================================================================
-- More challenging, application/scenario-based questions with subtler
-- distractors. Day 1 (already played) is left untouched.
-- Function-free / dollar-quote-free; each statement self-contained.
-- Idempotent for Days 2-20: clears those days' questions, then reseeds.
-- =============================================================================

delete from public.quiz_questions
where quiz_id in (
  select q.id from public.quizzes q
  join public.program_days d on d.id = q.day_id
  where d.day_number between 2 and 20
);


-- Day 2
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 1, 'A student writes: "Write my essay." and gets a generic result. Using the Role/Task/Constraints/Examples framework, what is the single biggest thing missing?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 2) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'All four — there is no role, specific task, constraints, or examples', true),
      (2, 'Only the word please', false),
      (3, 'A longer word count', false),
      (4, 'The AI''s name', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 2, 'Which prompt is strongest for getting a focused revision?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 2) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, '"You are an AP Lang teacher. Rewrite my conclusion in 3 different ways and explain each."', true),
      (2, '"Make my essay better."', false),
      (3, '"Fix this."', false),
      (4, '"Help me with English."', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 3, 'Why does adding a Role like "You are a NYC economics teacher" change the output even though it doesn''t change the model?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 2) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'It activates the right vocabulary, framing, and depth for the request', true),
      (2, 'It connects the model to a database of teachers', false),
      (3, 'It makes the model run on a different server', false),
      (4, 'It guarantees a factually correct answer', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 4, 'A prompt returns a good structure but the wrong reading level. Which element should you add or fix first?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 2) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Constraints (specify the audience/level)', true),
      (2, 'Delete the whole prompt and start over', false),
      (3, 'Add more examples of unrelated topics', false),
      (4, 'Change to a different AI tool', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 5, 'What is the best reason to include an Example in a prompt?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 2) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'To show the AI the exact format or style you want it to match', true),
      (2, 'To make the prompt longer', false),
      (3, 'To prove you already know the answer', false),
      (4, 'To slow the AI down', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 6, 'During a prompt battle, two students get different results from the same task. What most likely explains it?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 2) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Differences in how specifically each framed role, task, and constraints', true),
      (2, 'One laptop is faster', false),
      (3, 'The AI likes one student more', false),
      (4, 'Random luck only, nothing to learn', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 7, '"The AI doesn''t know what you want — it only knows what you said." What does this imply for vague prompts?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 2) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'The model fills gaps by guessing toward the most generic, average answer', true),
      (2, 'The model asks you clarifying questions every time', false),
      (3, 'The model refuses to respond', false),
      (4, 'The model always picks the best possible answer', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 8, 'Which is the clearest sign your prompting is improving?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 2) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'You get usable results in fewer iterations by front-loading role, task, and constraints', true),
      (2, 'Your prompts get shorter and vaguer', false),
      (3, 'You stop reading the outputs', false),
      (4, 'You use the same prompt for everything', false)
) as v(pos, label, correct);

-- Day 3
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 1, 'An LLM confidently states a fake statistic about your neighborhood. What is the most accurate explanation?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 3) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'It generated plausible text where its training data was thin, with no way to know it was wrong', true),
      (2, 'It intentionally lied', false),
      (3, 'It read a wrong website in real time', false),
      (4, 'It ran out of memory', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 2, 'A 2025 study found treatment recommendations changed when a patient''s race was stated. This is an example of what?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 3) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Bias learned from imbalances in training data surfacing in real outputs', true),
      (2, 'A software bug someone forgot to patch', false),
      (3, 'Random model noise', false),
      (4, 'Deliberate programming by doctors', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 3, 'Where does most AI bias originate?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 3) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'The patterns and imbalances in the massive text it was pre-trained on', true),
      (2, 'A single ''bias'' toggle', false),
      (3, 'The user''s phrasing alone', false),
      (4, 'The speed of the internet connection', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 4, 'What does RLHF (Reinforcement Learning from Human Feedback) do?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 3) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Shapes model behavior after pre-training using human ratings of responses', true),
      (2, 'Gives the model live internet access', false),
      (3, 'Stores your conversations permanently', false),
      (4, 'Translates between languages', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 5, 'Anthropic''s Constitutional AI differs from plain RLHF because Claude…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 3) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Critiques its own outputs against a set of explicit written principles', true),
      (2, 'Never uses any human feedback', false),
      (3, 'Cannot refuse any request', false),
      (4, 'Is trained only on medical data', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 6, 'Who holds responsibility for a biased or harmful AI output being used?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 3) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'The human using it — the model can''t know when it''s wrong, biased, or harmful', true),
      (2, 'The AI model itself', false),
      (3, 'Nobody, because it''s automated', false),
      (4, 'The internet as a whole', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 7, 'Which of these is the safest to paste into a public AI tool?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 3) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'A general question with no personal identifiers', true),
      (2, 'Your home address and school ID', false),
      (3, 'A family member''s medical history', false),
      (4, 'Your account password', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 8, 'Two models give different answers to the same ethics question. Why is that expected?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 3) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Each was shaped by different training data and different fine-tuning choices', true),
      (2, 'One model is broken', false),
      (3, 'Ethics questions have no answers', false),
      (4, 'The faster model is always right', false)
) as v(pos, label, correct);

-- Day 4
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 1, 'Using Trust But Verify, which AI-provided item most needs an independent source check?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 4) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'A specific statistic with a named study', true),
      (2, 'A general overview of the topic', false),
      (3, 'A list of key terms to explore', false),
      (4, 'A suggestion of what to research next', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 2, 'In the Trust But Verify steps, what is the correct role of the AI''s first ''orientation'' answer?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 4) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Use it to map the topic, but do not treat its specific claims as verified', true),
      (2, 'Copy it directly into your final report', false),
      (3, 'Assume it is fully accurate because it sounds confident', false),
      (4, 'Ignore it entirely', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 3, 'Which is a PRIMARY source?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 4) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'The original dataset or first-hand document itself', true),
      (2, 'A news article about the study', false),
      (3, 'An AI summary of the study', false),
      (4, 'A blog reacting to the news article', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 4, 'A confident AI answer with no citation should be treated as…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 4) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'An unverified claim until you find a credible source', true),
      (2, 'Correct, since confidence signals accuracy', false),
      (3, 'A primary source', false),
      (4, 'Automatically false', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 5, 'Which claim type is HIGHEST risk for AI hallucination?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 4) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'A specific named quote or study citation', true),
      (2, 'A broad definition of a common term', false),
      (3, 'A general historical trend', false),
      (4, 'A restatement of your own prompt', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 6, 'Good AI-assisted synthesis means the facts in your final piece are…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 4) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Your own verified facts, with AI helping organize and draft', true),
      (2, 'Whatever the AI generated, unchecked', false),
      (3, 'Only from one convenient source', false),
      (4, 'Left out to save time', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 7, 'You find the AI got a date wrong. The best move for your research artifact is to…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 4) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Correct it, cite the real source, and document the error as evidence of critical engagement', true),
      (2, 'Delete the whole project', false),
      (3, 'Keep the wrong date since the AI said it', false),
      (4, 'Hide that you used AI', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 8, 'Why is AI still a legitimate research tool despite hallucinating?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 4) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'It orients you and speeds synthesis — as long as you verify its specific claims', true),
      (2, 'It never makes mistakes on facts', false),
      (3, 'It replaces the need for sources', false),
      (4, 'It only works for opinions', false)
) as v(pos, label, correct);

-- Day 5
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 1, 'What makes a Personal AI Use Guide credible?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 5) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'It''s built from your own week of testing, failures, and reflection', true),
      (2, 'It''s copied from a popular website', false),
      (3, 'It only lists tool names', false),
      (4, 'It repeats the facilitator''s opinions', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 2, 'A strong, evidence-based tool preference sounds like…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 5) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, '"Claude held my structure for the Zap step; ChatGPT added extra text that broke it"', true),
      (2, '"Everyone says this one is best"', false),
      (3, '"I like its logo"', false),
      (4, '"It was the first one I opened"', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 3, 'Why will your AI framework stay useful as tools change?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 5) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'You know HOW to re-test and update it, not just what today''s answer is', true),
      (2, 'The tools will never change', false),
      (3, 'It''s carved in stone', false),
      (4, 'The facilitator updates it for you', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 4, 'Your Week 1 research artifact is presentation-ready when…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 5) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Its claims are backed by sources you personally verified', true),
      (2, 'It''s entirely AI-generated and unchecked', false),
      (3, 'It has the most words', false),
      (4, 'It matches a classmate''s', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 5, 'What is the core Week 1 deliverable?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 5) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'A Personal AI Use Guide plus a verified research artifact', true),
      (2, 'A finished animated video', false),
      (3, 'A working Zapier automation', false),
      (4, 'A cloned celebrity voice', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 6, 'A classmate says "ChatGPT is just better." The Week 1 skill says you should…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 5) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Ask for their specific evidence and test it against your own task', true),
      (2, 'Accept it because they sound sure', false),
      (3, 'Switch all your work to ChatGPT', false),
      (4, 'Ignore all tool comparisons', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 7, 'Reflection is emphasized in Week 1 because…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 5) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Documenting your reasoning is what lets you improve and adapt later', true),
      (2, 'It fills time', false),
      (3, 'Grades depend on word count', false),
      (4, 'The AI requires it', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 8, 'Which best shows Week 1 mastery?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 5) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'You can justify when and why to use each tool, with examples', true),
      (2, 'You memorized one perfect prompt', false),
      (3, 'You avoided testing to save time', false),
      (4, 'You used only one tool all week', false)
) as v(pos, label, correct);

-- Day 6
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 1, 'How should you use story structure when creating with AI?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 6) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'As a foundation to build on, adapting it to your story', true),
      (2, 'As rigid rules you can never break', false),
      (3, 'As something to ignore', false),
      (4, 'As a substitute for having any idea', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 2, 'Your Day 6 creative brief functions as…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 6) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'A ''creative constitution'' every prompt this week should serve', true),
      (2, 'Graded busywork with no further use', false),
      (3, 'The finished media piece', false),
      (4, 'A list of tools to install', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 3, 'Why generate story concepts across three platforms before committing?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 6) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Different tools surface different angles, so you can pick the strongest', true),
      (2, 'It''s legally required to use all three', false),
      (3, 'Only one tool can write stories', false),
      (4, 'To make the project take longer', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 4, 'A prompt this week produces something off-tone. The brief helps by…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 6) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Giving you a fixed reference for audience, mood, and intent to steer back to', true),
      (2, 'Telling the AI to ignore your goals', false),
      (3, 'Replacing the need to edit', false),
      (4, 'Choosing the tool for you', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 5, 'Which is the best-scoped story concept for a week-long project?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 6) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'A focused piece with a clear audience and beginning/middle/end', true),
      (2, 'An epic feature film with 50 scenes', false),
      (3, 'A single random image', false),
      (4, 'A vague ''something about AI''', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 6, 'The creative brief mainly captures…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 6) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Your concept, direction, audience, and intent', true),
      (2, 'Your account passwords', false),
      (3, 'The model''s training data', false),
      (4, 'Unrelated trivia', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 7, 'Comparing AI outputs to your brief, you should keep the one that…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 6) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Best serves your intended audience and message', true),
      (2, 'Is longest', false),
      (3, 'The AI generated first', false),
      (4, 'Uses the most tools', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 8, 'Story structure is described as a ''foundation, not a formula'' because…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 6) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'You use it to build on with judgment, not fill in mechanically', true),
      (2, 'It must be followed exactly every time', false),
      (3, 'It doesn''t matter at all', false),
      (4, 'It''s only for novels', false)
) as v(pos, label, correct);

-- Day 7
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 1, 'Two image prompts differ only in that one adds "soft side lighting, muted palette, wide composition." What will that change?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 7) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'It gives more precise control over the look of the output', true),
      (2, 'Nothing — those words are ignored', false),
      (3, 'It slows the computer down', false),
      (4, 'It picks a random unrelated image', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 2, 'Your first generated image isn''t quite right. The Day 7 mindset says to…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 7) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Treat it as a draft and iterate on the prompt', true),
      (2, 'Keep it as the final, since first is final', false),
      (3, 'Assume the tool is broken', false),
      (4, 'Give up on the image', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 3, 'Which prompt gives the most precise result?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 7) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, '"Neon-lit rainy Brooklyn street at night, cinematic, low angle"', true),
      (2, '"A cool picture"', false),
      (3, '"Something nice"', false),
      (4, '"Make art"', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 4, 'You need five images that look like one series. The key is…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 7) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Consistent style descriptors (lighting, palette, mood) across prompts', true),
      (2, 'Using a totally different style each time', false),
      (3, 'Generating once and never adjusting', false),
      (4, 'Adding text instead of images', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 5, 'Iterating on an image prompt is best understood as…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 7) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Refining a draft toward your vision', true),
      (2, 'Evidence your first prompt failed', false),
      (3, 'A waste of time', false),
      (4, 'A sign to switch tools', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 6, 'Why does vague input like "a nice logo" produce weak images?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 7) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'The model has no specific direction, so it defaults to generic output', true),
      (2, 'The model dislikes short prompts', false),
      (3, 'It''s against the rules', false),
      (4, 'It always crashes', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 7, 'Specificity in a visual prompt translates most directly into…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 7) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Precision and control in the output', true),
      (2, 'A slower render only', false),
      (3, 'Fewer options', false),
      (4, 'A random image', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 8, 'Which change would most improve consistency of characters across images?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 7) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Reusing the same detailed descriptors and style each time', true),
      (2, 'Changing the art style every image', false),
      (3, 'Removing all descriptors', false),
      (4, 'Switching tools each image', false)
) as v(pos, label, correct);

-- Day 8
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 1, 'You need a narrated voiceover from a script. Which tool fits?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 8) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'ElevenLabs (text-to-speech)', true),
      (2, 'Suno', false),
      (3, 'Zapier', false),
      (4, 'Google Forms', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 2, 'You want an original background music track. Which tool?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 8) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Suno', true),
      (2, 'ElevenLabs', false),
      (3, 'Pika', false),
      (4, 'Google Sheets', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 3, 'You need a short AI-generated video clip. Which tools apply?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 8) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Google Veo 3.1 or Pika', true),
      (2, 'ElevenLabs or Suno', false),
      (3, 'Zapier or Sheets', false),
      (4, 'Claude or Gemini text chat', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 4, 'A student clones a classmate''s voice without asking. The main issue is…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 8) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Consent — synthetic media of someone''s likeness requires permission', true),
      (2, 'The file size', false),
      (3, 'The video resolution', false),
      (4, 'The thumbnail color', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 5, 'After Day 8 you have drafts of which three production layers?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 8) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Visual, audio, and motion', true),
      (2, 'Code, data, and forms', false),
      (3, 'Email, chat, and calendar', false),
      (4, 'Intro, body, conclusion', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 6, 'Why is voice cloning called ''extraordinary technology with serious ethical dimensions''?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 8) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'It can convincingly imitate a real person, which can deceive or harm', true),
      (2, 'It''s slow to run', false),
      (3, 'It only works in one language', false),
      (4, 'It costs too much', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 7, 'You have great clips but they don''t fit together yet. Day 8''s point is…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 8) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'The edit (tomorrow) is where the pieces become one story', true),
      (2, 'The raw clips are already the final piece', false),
      (3, 'Editing is unnecessary', false),
      (4, 'More clips always fix it', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 8, 'Which is the most responsible use of AI audio/video for your project?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 8) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Generating original assets and disclosing the tools used', true),
      (2, 'Impersonating a public figure without labeling it', false),
      (3, 'Copying a copyrighted song as your own', false),
      (4, 'Using someone''s voice secretly', false)
) as v(pos, label, correct);

-- Day 9
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 1, 'In AI-assisted work, the human creator''s core value is…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 9) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Curation, editing, and judgment about what serves the story', true),
      (2, 'Generating the most files', false),
      (3, 'Letting the AI decide everything', false),
      (4, 'Avoiding editing', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 2, '"The edit is where the story lives" means…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 9) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Your selection and arrangement of raw material shapes the actual meaning', true),
      (2, 'The first clip is automatically the story', false),
      (3, 'File names carry the meaning', false),
      (4, 'Settings decide the story', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 3, 'Which set of editing principles applies to your rough cut?', 'mc', 25 from public.quizzes
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
  select id, 4, 'Structured peer critique is most useful because it…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 9) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Surfaces specific gaps you can target with new generations', true),
      (2, 'Ranks students against each other', false),
      (3, 'Decides who may use the AI', false),
      (4, 'Prevents any changes', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 5, 'A proper creative statement + AI attribution does what?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 9) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Honestly explains your process and credits the AI tools used', true),
      (2, 'Hides that AI was used', false),
      (3, 'Lists your passwords', false),
      (4, 'Replaces the project', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 6, 'You spot a pacing problem near your ending. The right response is…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 9) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Do a targeted re-generation or re-edit to fix that section', true),
      (2, 'Leave it since the AI made it', false),
      (3, 'Delete the whole project', false),
      (4, 'Add unrelated clips', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 7, 'AI generates many options quickly. Your job is to…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 9) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Decide which options serve the story and cut the rest', true),
      (2, 'Keep every option in the final', false),
      (3, 'Use them all without judgment', false),
      (4, 'Pick randomly', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 8, 'Which best demonstrates that a piece is genuinely yours?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 9) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Visible, defensible decisions about what to include and why', true),
      (2, 'It looks like everyone else''s', false),
      (3, 'Removing your name changes nothing', false),
      (4, 'You can''t explain any choice', false)
) as v(pos, label, correct);

-- Day 10
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 1, 'The phrase ''AI-assisted creator'' emphasizes which word, and why?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 10) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Creator — you supplied vision, judgment, and editing', true),
      (2, 'Assisted — the AI did the real work', false),
      (3, 'AI — the tool deserves credit', false),
      (4, 'None — they''re equal', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 2, 'A strong Day 10 presentation clearly articulates…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 10) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Your process, tool choices, and design decisions', true),
      (2, 'Only the final output with no context', false),
      (3, 'The AI''s training data', false),
      (4, 'Classmates'' PINs', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 3, 'Asked "Why this tool for this step?", a strong answer is…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 10) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'A specific, tested reason tied to your project''s needs', true),
      (2, '"Because we used it in the program"', false),
      (3, '"It was first alphabetically"', false),
      (4, '"I don''t know"', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 4, 'What did the human bring that the AI did not?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 10) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Vision, judgment, specificity, and final selection', true),
      (2, 'Raw generation speed', false),
      (3, 'Unlimited storage', false),
      (4, 'Token prediction', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 5, 'Giving and receiving structured feedback helps you…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 10) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'See your work clearly and improve it', true),
      (2, 'Win points by attacking others', false),
      (3, 'Avoid ever revising', false),
      (4, 'Skip presenting', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 6, 'Week 2''s core lesson about human+AI collaboration is…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 10) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Together you made something neither could alone', true),
      (2, 'AI should do everything', false),
      (3, 'Humans are now unnecessary', false),
      (4, 'Creativity no longer matters', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 7, 'Which is the weakest justification in a demo?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 10) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, '"Because the program told us to use it"', true),
      (2, '"It preserved my formatting downstream"', false),
      (3, '"It matched the tone I defined"', false),
      (4, '"I tested both and this held up"', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 8, 'The most important evidence that you directed the AI is…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 10) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Specific decisions visible in the final piece', true),
      (2, 'A long runtime', false),
      (3, 'Many tools used', false),
      (4, 'A fancy title', false)
) as v(pos, label, correct);

-- Day 11
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 1, 'Which everyday scenario matches the Trigger to Action pattern?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 11) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'New form submission (trigger) sends a Slack message (action)', true),
      (2, 'A photo that just sits in a folder', false),
      (3, 'A document with no automation', false),
      (4, 'A printed poster', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 2, 'What distinguishes an AI agent from a traditional automation?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 11) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'The agent can handle inputs no fixed rule anticipated', true),
      (2, 'They are identical', false),
      (3, 'Agents can only send email', false),
      (4, 'Traditional automation is always smarter', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 3, 'In ''Trigger to Action'', the trigger is…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 11) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'The event that starts the automation', true),
      (2, 'The final output', false),
      (3, 'An error message', false),
      (4, 'The person who built it', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 4, 'The ''intelligence'' of an automation depends most on…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 11) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'What logic you build into each step', true),
      (2, 'Your internet speed', false),
      (3, 'The interface color', false),
      (4, 'Number of accounts', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 5, 'Which tool does the camp use to build automations?', 'mc', 25 from public.quizzes
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
  select id, 6, 'Why is ''automation isn''t magic, it''s logic'' an important framing?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 11) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Every automation reduces to trigger + chained actions you can reason about', true),
      (2, 'Automations can''t be understood', false),
      (3, 'Logic doesn''t matter', false),
      (4, 'Only experts can build them', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 7, 'A daily reminder text sent by your phone is an example of…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 11) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'A simple trigger (time) to action (send text) automation', true),
      (2, 'An AI agent making judgments', false),
      (3, 'A random event', false),
      (4, 'A manual task', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 8, 'Which is TRUE about a rule-based automation facing an unexpected input?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 11) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'It may fail because no rule was written for that case', true),
      (2, 'It always adapts intelligently', false),
      (3, 'It rewrites its own rules', false),
      (4, 'It calls a human automatically', false)
) as v(pos, label, correct);

-- Day 12
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 1, 'A Zap step shows the wrong data in an email. The most likely cause is…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 12) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Incorrect field mapping from a previous step', true),
      (2, 'The internet is down', false),
      (3, 'The AI is biased', false),
      (4, 'The trigger is too fast', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 2, '''Field mapping'' in Zapier means…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 12) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Telling each step which data from earlier steps to use', true),
      (2, 'Drawing a floor plan', false),
      (3, 'Changing the theme', false),
      (4, 'Deleting old Zaps', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 3, 'When a Zap errors, the error message is best used to…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 12) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Locate where the logic failed and fix it', true),
      (2, 'Ignore it and rerun forever', false),
      (3, 'Delete the account', false),
      (4, 'Prove Zapier is broken', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 4, 'A correctly working Zap should…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 12) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Run silently in the background when triggered', true),
      (2, 'Pop up a confirmation every second', false),
      (3, 'Require manual running each time', false),
      (4, 'Show errors even when correct', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 5, '''Automation is logic made visible'' implies that when it breaks…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 12) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'You can trace the failing step because each step is explicit', true),
      (2, 'It''s impossible to debug', false),
      (3, 'You must start a new account', false),
      (4, 'Logic is irrelevant', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 6, 'A basic Zap consists of…', 'mc', 25 from public.quizzes
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
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 7, 'You add a filter step so the Zap only runs for VIP entries. This changes the Zap by…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 12) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Adding conditional logic so actions run only when criteria are met', true),
      (2, 'Making it run for everything always', false),
      (3, 'Removing the trigger', false),
      (4, 'Deleting the action', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 8, 'Best first move when a new Zap doesn''t fire at all?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 12) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Check the trigger and its test data, then the mappings', true),
      (2, 'Rebuild the whole account', false),
      (3, 'Assume Zapier is down', false),
      (4, 'Add more unrelated steps', false)
) as v(pos, label, correct);

-- Day 13
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 1, 'You add an AI step to a Zap. To make its prompt use real submission data you must…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 13) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Insert Zapier variable fields into the prompt', true),
      (2, 'Type the same fixed text every run', false),
      (3, 'Leave the prompt empty', false),
      (4, 'Use only emojis', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 2, 'Why is AI-powered automation different from rule-based?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 13) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'It can handle inputs no rule-writer anticipated', true),
      (2, 'It''s always cheaper', false),
      (3, 'It never errs', false),
      (4, 'It can''t use variables', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 3, 'Because an AI step can be wrong, a responsible design includes…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 13) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'A safeguard for what happens when the AI output is wrong', true),
      (2, 'Only a faster connection', false),
      (3, 'A prettier interface', false),
      (4, 'More triggers', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 4, 'Which is a real safeguard on an AI automation?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 13) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Route low-confidence or flagged outputs to a human for review', true),
      (2, 'Assume the AI is always right', false),
      (3, 'Remove all error handling', false),
      (4, 'Hide the outputs', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 5, 'The flexibility of AI automation comes with…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 13) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'A design responsibility to plan for failure cases', true),
      (2, 'A guarantee of perfect output', false),
      (3, 'No trade-offs', false),
      (4, 'Fewer steps automatically', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 6, 'A dynamic AI prompt in Zapier is ''dynamic'' because…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 13) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'It changes per run using data mapped from earlier steps', true),
      (2, 'It is identical every time', false),
      (3, 'It has no inputs', false),
      (4, 'It only outputs emojis', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 7, 'An AI triage Zap mislabels an urgent message as low priority. The safeguard should…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 13) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Catch or escalate uncertain cases so a human can check', true),
      (2, 'Delete the message', false),
      (3, 'Trust the label anyway', false),
      (4, 'Turn off the Zap permanently', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 8, 'Which best captures rule-based vs AI-powered automation?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 13) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Rules follow fixed conditions; AI interprets messy, unanticipated inputs', true),
      (2, 'They are the same', false),
      (3, 'AI is always simpler', false),
      (4, 'Rules are always smarter', false)
) as v(pos, label, correct);

-- Day 14
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 1, 'A ''structured output'' from an AI is one that…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 14) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Comes in a consistent, parseable format an automation can use', true),
      (2, 'Is a long unformatted paragraph', false),
      (3, 'Changes shape every time', false),
      (4, 'Is an image', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 2, 'The full pipeline you assemble for the mini-project is…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 14) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Form + AI analysis + structured output + safeguard', true),
      (2, 'Video + music + voiceover', false),
      (3, 'Role + Task + Constraints + Examples', false),
      (4, 'Trigger only, no actions', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 3, 'Why does form design matter so much for automation?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 14) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Clean, structured input data is what makes the downstream steps reliable', true),
      (2, 'Forms only affect colors', false),
      (3, 'Forms are unrelated to automation', false),
      (4, 'Forms slow everything', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 4, 'A gap anywhere in the data chain typically shows up as…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 14) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'A failure when the automation runs on real inputs', true),
      (2, 'A hidden bonus feature', false),
      (3, 'Faster performance', false),
      (4, 'Nothing at all', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 5, 'Which prompt is most likely to return automation-ready output?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 14) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, '"Return ONLY JSON with keys name, priority (high/med/low), summary"', true),
      (2, '"Tell me about this entry"', false),
      (3, '"Write a nice paragraph"', false),
      (4, '"Do your best"', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 6, 'Why consider data privacy in an automated workflow?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 14) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'It moves real people''s data, so it must be handled responsibly', true),
      (2, 'Privacy only matters for images', false),
      (3, 'Automations never touch real data', false),
      (4, 'Privacy is the AI''s job', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 7, 'An AI step sometimes returns extra prose that breaks the next step. The best fix is…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 14) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Constrain the prompt to output only the exact structured format needed', true),
      (2, 'Ignore it and hope', false),
      (3, 'Add more free-text fields', false),
      (4, 'Remove the next step', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 8, 'Good automation ''starts with good data'' because…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 14) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Every later step depends on the input being well-structured', true),
      (2, 'Data is decorative', false),
      (3, 'The AI fixes any input automatically', false),
      (4, 'Structure is optional', false)
) as v(pos, label, correct);

-- Day 15
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 1, 'Your Week 3 automation''s value is best described as…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 15) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'It does real work without you — a professional capability', true),
      (2, 'It printed ''hello'' once', false),
      (3, 'It generated a video', false),
      (4, 'It cloned a voice', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 2, 'When presenting your automation, you must explain…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 15) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'The problem it solves and the design decisions behind it', true),
      (2, 'Only that it exists', false),
      (3, 'Your password', false),
      (4, 'The AI''s training data', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 3, 'The reusable automation pattern you learned is…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 15) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Form + AI analysis + structured output + safeguard', true),
      (2, 'A trigger with no action', false),
      (3, 'One chat message', false),
      (4, 'A video timeline', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 4, 'A safeguard exists in your automation to…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 15) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Handle cases where the AI or data is wrong', true),
      (2, 'Make it run faster', false),
      (3, 'Add colors', false),
      (4, 'Replace the trigger', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 5, 'Why does the architecture matter beyond camp?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 15) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Real companies and organizations use this same pattern', true),
      (2, 'It only works in class', false),
      (3, 'It''s used nowhere else', false),
      (4, 'Only researchers use it', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 6, 'A demo where you submit a live form and walk each step is strong because…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 15) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'It shows the automation actually working end to end', true),
      (2, 'It hides how it works', false),
      (3, 'It avoids explaining decisions', false),
      (4, 'It skips the safeguard', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 7, 'Which automation would score poorly?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 15) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'A Zap that logs data but solves no real problem', true),
      (2, 'A form-to-AI-to-action pipeline with a safeguard', false),
      (3, 'An AI triage with human escalation', false),
      (4, 'A digest that summarizes and emails content', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 8, 'The clearest sign your automation is ''real''?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 15) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'It reliably produces a useful result for a specific audience', true),
      (2, 'It has the most steps', false),
      (3, 'It uses the newest tool', false),
      (4, 'It looks complex', false)
) as v(pos, label, correct);

-- Day 16
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 1, 'Two students pitch capstones. Whose is more likely to succeed?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 16) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'The one with a smaller, honestly-scoped MVP they can finish in the time', true),
      (2, 'The one with the most ambitious 50-feature plan', false),
      (3, 'The flashier idea regardless of scope', false),
      (4, 'The one copied from a classmate', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 2, 'Most capstones fail because…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 16) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'The scope was unrealistic, not because the idea was bad', true),
      (2, 'The idea was too simple', false),
      (3, 'They used AI tools', false),
      (4, 'They finished too early', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 3, 'An ''MVP'' for your capstone is…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 16) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'The minimum viable product — the core you can actually build and demo', true),
      (2, 'The most valuable person', false),
      (3, 'A marketing plan', false),
      (4, 'A maxed-out version with everything', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 4, 'Which capstone meets ''uses AI as a tool, not the author''?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 16) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'You generated 12 drafts, chose one, rewrote it, and directed the visuals', true),
      (2, 'You pressed generate once and submitted it', false),
      (3, 'You screenshotted a chat', false),
      (4, 'You copied output unchanged', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 5, 'Which is a real capstone, not just a ''project''?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 16) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'A 2-min explainer made for a named audience with a specific purpose', true),
      (2, '"A video about AI"', false),
      (3, 'A pile of images with no story', false),
      (4, 'A chat you printed', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 6, 'Your one-page brief should include…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 16) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'A defined MVP scope and a day-by-day build plan', true),
      (2, 'Only a title', false),
      (3, 'A list of unrelated ideas', false),
      (4, 'Your password', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 7, 'If removing your name from the capstone ''wouldn''t change anything'', it means…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 16) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Your judgment isn''t visible yet — rework it', true),
      (2, 'It''s finished', false),
      (3, 'It''s the best kind of project', false),
      (4, 'AI did it perfectly', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 8, 'A ''hybrid'' capstone qualifies only when…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 16) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Both components are substantive enough to stand alone', true),
      (2, 'One part is a 30-second add-on', false),
      (3, 'It uses two tools', false),
      (4, 'It has a long title', false)
) as v(pos, label, correct);

-- Day 17
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 1, 'Professional build-day discipline for Day 17 is…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 17) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Stand-up, task list, focus, check-out', true),
      (2, 'Sleep, snack, scroll, leave', false),
      (3, 'Only a final demo', false),
      (4, 'Unstructured free time', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 2, 'Why tackle your highest-risk assumption early?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 17) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'If it''s wrong, you find out while there''s still time to adjust', true),
      (2, 'It''s the easiest task', false),
      (3, 'It impresses the audience', false),
      (4, 'Risk doesn''t matter', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 3, 'A morning stand-up is…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 17) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'A short meeting to state your plan/goals for the day', true),
      (2, 'A workout break', false),
      (3, 'The final presentation', false),
      (4, 'A grading session', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 4, 'A good end-of-Day-17 outcome is…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 17) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Your first tangible asset or working component', true),
      (2, 'A finished, polished project', false),
      (3, 'Nothing yet, just ideas', false),
      (4, 'A brand-new project to restart', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 5, 'You should end the day with…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 17) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Clear, specific goals for Day 18', true),
      (2, 'No plan for tomorrow', false),
      (3, 'A request to switch projects', false),
      (4, 'A deleted project', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 6, 'Why does the curriculum say projects ''feel hardest at the beginning''?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 17) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Before the work is real, it''s abstract; a working component changes that', true),
      (2, 'Because the end is always easy', false),
      (3, 'Because AI does the middle', false),
      (4, 'Because scope doesn''t matter', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 7, 'Which is the best use of a build-day task list?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 17) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Break the MVP into concrete, checkable steps for the day', true),
      (2, 'List every possible future feature', false),
      (3, 'Write only one vague goal', false),
      (4, 'Skip it to save time', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 8, 'Highest-risk assumption for a live-demo automation might be…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 17) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, '"The AI step will reliably return the format my next step needs"', true),
      (2, '"My slides have a nice font"', false),
      (3, '"The room has chairs"', false),
      (4, '"My title is catchy"', false)
) as v(pos, label, correct);

-- Day 18
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 1, '''Integration'' in your project means…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 18) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Getting all major components working together as one coherent whole', true),
      (2, 'Starting a new project', false),
      (3, 'Deleting half your work', false),
      (4, 'Adding as many features as possible', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 2, 'Why is integration often the hardest part?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 18) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'It exposes everything that doesn''t fit together', true),
      (2, 'It''s the easiest step', false),
      (3, 'Nothing goes wrong in it', false),
      (4, 'It needs no testing', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 3, 'A good end-of-Day-18 state is a project that…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 18) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Can be tested by someone other than you', true),
      (2, 'Only you understand', false),
      (3, 'Has no working parts', false),
      (4, 'Was just started', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 4, 'Mid-day facilitator feedback should be…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 18) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Acted on to improve the project', true),
      (2, 'Ignored to save time', false),
      (3, 'Argued with on principle', false),
      (4, 'Saved until after Demo Day', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 5, 'Day 18 moves your project from…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 18) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Individual parts to a demo-able whole', true),
      (2, 'A whole back to scattered parts', false),
      (3, 'One idea to a new idea', false),
      (4, 'Finished to unfinished', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 6, 'A sign your integration is incomplete is…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 18) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Parts work alone but break when connected', true),
      (2, 'Everything works end to end', false),
      (3, 'A stranger can use it', false),
      (4, 'The demo runs cleanly', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 7, 'Best response when two components won''t connect?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 18) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Debug the interface between them (the data/format they share)', true),
      (2, 'Delete both and restart', false),
      (3, 'Ignore it and present anyway', false),
      (4, 'Add a third unrelated component', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 8, 'Why have someone else test your project on Day 18?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 18) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'They reveal assumptions and gaps you can''t see yourself', true),
      (2, 'To rank students', false),
      (3, 'To slow you down', false),
      (4, 'To copy your work', false)
) as v(pos, label, correct);

-- Day 19
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 1, 'A ''feature freeze'' on Day 19 means…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 19) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Stop adding features and focus on testing, fixing, and rehearsing', true),
      (2, 'Add as many features as possible', false),
      (3, 'Delete all features', false),
      (4, 'Freeze your laptop', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 2, 'Why is rehearsal called the most important part of presenting?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 19) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Practiced presenters know what to say/show and stay relaxed', true),
      (2, 'It impresses no one', false),
      (3, 'It replaces building', false),
      (4, 'It''s only for shy people', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 3, 'How many full rehearsals does the guide recommend?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 19) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'At least two', true),
      (2, 'Zero — wing it', false),
      (3, 'Only one', false),
      (4, 'Only silently in your head', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 4, 'Stress-testing your project means…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 19) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Having peers/facilitators actually try it and surface problems', true),
      (2, 'Making it look pretty', false),
      (3, 'Hiding the bugs', false),
      (4, 'Adding more code', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 5, 'Late on Day 19 you find a small bug and a tempting new feature. Best move?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 19) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Fix the bug; resist the feature (feature freeze) and rehearse', true),
      (2, 'Add the feature, skip the fix', false),
      (3, 'Add both and skip rehearsal', false),
      (4, 'Do nothing', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 6, 'Who tends to present best on Demo Day?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 19) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Those who rehearsed enough to be confident', true),
      (2, 'Those with the most features', false),
      (3, 'Those who skipped practice', false),
      (4, 'Those who built the biggest thing', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 7, 'The purpose of a Day 19 rehearsal is to know…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 19) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Exactly what you''ll say and show, and where it might break', true),
      (2, 'Nothing in advance', false),
      (3, 'Only your title', false),
      (4, 'Your competitors'' scripts', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 8, 'A good rehearsal outcome is discovering that…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 19) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Your live demo step is fragile, so you prepare a fallback', true),
      (2, 'Everything is perfect, no need to check', false),
      (3, 'Rehearsal wasted time', false),
      (4, 'You should add features', false)
) as v(pos, label, correct);

-- Day 20
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 1, 'What is Demo Day?', 'mc', 25 from public.quizzes
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
  select id, 2, 'Which is one of the six rubric dimensions?', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 20) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Human Judgment — Visible', true),
      (2, 'Font choice', false),
      (3, 'Video length', false),
      (4, 'Number of slides', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 3, 'A guest asks "Why Claude over ChatGPT here?" A strong answer is…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 20) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'A specific, tested reason tied to your project''s needs', true),
      (2, '"Because the program used it"', false),
      (3, '"I''m not sure"', false),
      (4, '"It was first"', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 4, 'The rubric''s ''Real Audience or Problem'' dimension rewards…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 20) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'A specific, named audience the project is actually for', true),
      (2, 'A vague ''everyone''', false),
      (3, 'No audience at all', false),
      (4, 'The flashiest visuals', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 5, 'Across four weeks, your portfolio includes…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 20) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'An AI media piece, a working automation, and a capstone', true),
      (2, 'Only a certificate', false),
      (3, 'Only a quiz score', false),
      (4, 'Nothing tangible', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 6, '''Live Demo Quality'' in the rubric means the demo…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 20) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Works and shows the project clearly without excessive explanation', true),
      (2, 'Is described but never shown', false),
      (3, 'Plays while you stand silently', false),
      (4, 'Is skipped entirely', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 7, '''Reflection and Learning'' rewards a presenter who…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 20) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Shows genuine insight about what they learned and would change', true),
      (2, 'Claims everything was perfect', false),
      (3, 'Avoids discussing challenges', false),
      (4, 'Only reads slides', false)
) as v(pos, label, correct);
with q as (
  insert into public.quiz_questions (quiz_id, position, prompt, question_type, time_limit_seconds)
  select id, 8, 'The program''s biggest takeaway is that you can…', 'mc', 25 from public.quizzes
   where day_id = (select id from public.program_days where day_number = 20) limit 1
  returning id
)
insert into public.quiz_options (question_id, position, label, is_correct)
select q.id, v.pos, v.label, v.correct
from q, (values
      (1, 'Direct AI to create, build, and present real work — a creator, not just a user', true),
      (2, 'Only open a chatbot and type', false),
      (3, 'Never use AI again', false),
      (4, 'Let AI do all your thinking', false)
) as v(pos, label, correct);
