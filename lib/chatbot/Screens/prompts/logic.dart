import 'package:get/get.dart';

class PromptsLogic extends GetxController {
  List<Map<String, dynamic>> prompts = [
    {
      'category': 'Sales',
      'icon': '🏷️',
      'prompts': [
        'How can I improve my cold email strategy?',
        'Create a compelling elevator pitch for my product.',
        'Generate a follow-up message after a product demo.',
        'Write a sales script for outbound calls.',
        'How do I overcome objections in B2B sales?',
      ],
    },
    {
      'category': 'Digital Marketing',
      'icon': '🚀',
      'prompts': [
        'Write an Instagram ad for a fitness brand.',
        'Create a Google Ads headline for a bakery.',
        'How can I improve my email open rates?',
        'Suggest A/B testing ideas for a landing page.',
        'Write SEO meta descriptions for a travel blog.',
      ],
    },
    {
      'category': '3D Art',
      'icon': '🎨',
      'prompts': [
        'Suggest a concept for a sci-fi 3D environment.',
        'How do I optimize a 3D model for mobile?',
        'Give me a text prompt for a 3D AI art generator.',
        'Describe a fantasy creature for sculpting practice.',
        'List lighting tips for realistic rendering in Blender.',
      ],
    },
    {
      'category': 'Design',
      'icon': '💡',
      'prompts': [
        'Design a modern UI for a finance app.',
        'Give me color palette ideas for a nature brand.',
        'How can I improve UX on a product page?',
        'Write microcopy for a login form.',
        'Generate ideas for a logo redesign project.',
      ],
    },
    {
      'category': 'Email',
      'icon': '📩',
      'prompts': [
        'Write a welcome email for a new user.',
        'Create a subject line for a limited-time sale.',
        'Generate a re-engagement email for inactive users.',
        'How do I write a professional email apology?',
        'Draft a newsletter introduction for a tech brand.',
      ],
    },
    {
      'category': 'Social Media',
      'icon': '❤️',
      'prompts': [
        'Write a caption for a Monday motivation post.',
        'Give me TikTok content ideas for skincare.',
        'How do I engage followers in Instagram Stories?',
        'Create a social media challenge for a brand launch.',
        'Write a tweet promoting a blog post.',
      ],
    },
    {
      'category': 'Fashion',
      'icon': '👗',
      'prompts': [
        'What are the current streetwear trends?',
        'Describe an outfit inspired by the 90s.',
        'Suggest fashion content ideas for Instagram.',
        'How to build a minimalist capsule wardrobe?',
        'Write a blog intro on sustainable fashion.',
      ],
    },
    {
      'category': 'Travel',
      'icon': '✈️',
      'prompts': [
        'Plan a 7-day itinerary for Japan.',
        'List travel essentials for backpackers.',
        'Describe a perfect weekend in Paris.',
        'How do I find cheap flights in Europe?',
        'Suggest blog ideas for travel influencers.',
      ],
    },
    {
      'category': 'History',
      'icon': '🏰',
      'prompts': [
        'Explain the causes of World War I.',
        'Describe life in Ancient Rome.',
        'Summarize the American Civil Rights Movement.',
        'Who was Cleopatra and why was she important?',
        'Compare the Renaissance and Enlightenment periods.',
      ],
    },
    {
      'category': 'Philosophy',
      'icon': '🔮',
      'prompts': [
        'What is existentialism?',
        'Compare Kant and Nietzsche’s ethics.',
        'What is the Ship of Theseus paradox?',
        'Describe Plato’s Allegory of the Cave.',
        'Discuss free will vs determinism.',
      ],
    },
    {
      'category': 'Finance',
      'icon': '💸',
      'prompts': [
        'Explain compound interest to a beginner.',
        'How do I create a monthly budget?',
        'What’s the difference between stocks and ETFs?',
        'Generate a retirement saving plan for a 30-year-old.',
        'List financial goals for new college graduates.',
      ],
    },
    {
      'category': 'Spirituality',
      'icon': '📿',
      'prompts': [
        'Guide me through a 5-minute meditation.',
        'What are chakras and how do they work?',
        'Write a daily gratitude affirmation.',
        'Explain the concept of karma.',
        'How do I start a spiritual journaling practice?',
      ],
    },
    {
      'category': 'Media',
      'icon': '🎥',
      'prompts': [
        'Write a movie review for a thriller.',
        'Describe the role of media in elections.',
        'Suggest ideas for a YouTube documentary.',
        'How do I write a compelling news article?',
        'List podcast topics for a media agency.',
      ],
    },
    {
      'category': 'Growth',
      'icon': '📈',
      'prompts': [
        'Create a personal growth plan for 6 months.',
        'How do I track habits effectively?',
        'List morning routines of successful people.',
        'What are common traits of high achievers?',
        'Write a vision statement for personal growth.',
      ],
    },
    {
      'category': 'Sing',
      'icon': '🎤',
      'prompts': [
        'Write lyrics for a breakup song.',
        'How do I improve my vocal range?',
        'Create a warm-up routine for singers.',
        'Suggest harmony ideas for a pop chorus.',
        'Write a hook for an R&B track.',
      ],
    },
    {
      'category': 'Recipe',
      'icon': '👨‍🍳',
      'prompts': [
        'Give me a vegan dinner recipe.',
        'How to make homemade pasta from scratch?',
        'Suggest 5-minute breakfast ideas.',
        'Write a recipe for chocolate chip cookies.',
        'What’s a traditional dish from Morocco?',
      ],
    },
    {
      'category': 'Technology',
      'icon': '🤖',
      'prompts': [
        'Explain how blockchain works.',
        'What are the benefits of 5G?',
        'How do neural networks function?',
        'Summarize the history of the internet.',
        'List top programming languages in 2025.',
      ],
    },
    {
      'category': 'Business',
      'icon': '💼',
      'prompts': [
        'Write a mission statement for a startup.',
        'How do I validate a business idea?',
        'Create a SWOT analysis for an online store.',
        'What are key elements of a business plan?',
        'Generate product ideas for a subscription box.',
      ],
    },
    {
      'category': 'Hobbies',
      'icon': '🚴',
      'prompts': [
        'Suggest unique hobbies to try in 2025.',
        'How do I start painting as a hobby?',
        'What are beginner-friendly DIY projects?',
        'List tools needed for woodworking.',
        'Describe the benefits of journaling.',
      ],
    },
    {
      'category': 'Education',
      'icon': '🎓',
      'prompts': [
        'How do I improve my study habits?',
        'Explain the Pomodoro technique.',
        'Write a motivational quote for students.',
        'List fun facts about world education systems.',
        'Create a lesson plan for high school history.',
      ],
    },
    {
      'category': 'Environment',
      'icon': '🌍',
      'prompts': [
        'How do I reduce my carbon footprint?',
        'What are the causes of climate change?',
        'List eco-friendly products for daily use.',
        'Describe the impact of deforestation.',
        'Write a campaign message for Earth Day.',
      ],
    },
    {
      'category': 'Lawyer',
      'icon': '⚖️',
      'prompts': [
        'Explain contract law in simple terms.',
        'What is intellectual property?',
        'Create a checklist for a legal agreement.',
        'How do I prepare for a court case?',
        'List rights employees should know.',
      ],
    },
    {
      'category': 'Science',
      'icon': '🔬',
      'prompts': [
        'Explain Newton’s laws of motion.',
        'What is CRISPR technology?',
        'Describe the water cycle.',
        'What are black holes?',
        'List recent breakthroughs in space science.',
      ],
    },
    {
      'category': 'Relation',
      'icon': '🤝',
      'prompts': [
        'How do I build trust in a relationship?',
        'Write a text to apologize sincerely.',
        'Suggest activities for long-distance couples.',
        'How to handle conflict in friendships?',
        'What are signs of healthy communication?',
      ],
    },
    {
      'category': 'Language',
      'icon': '🗣️',
      'prompts': [
        'Give me 10 common French phrases.',
        'How do I practice English pronunciation?',
        'Translate “Good morning” into 5 languages.',
        'What are useful tips for learning Japanese?',
        'Write a tongue twister for Spanish learners.',
      ],
    },
    {
      'category': 'Entertainment',
      'icon': '🎭',
      'prompts': [
        'Write a movie plot for a mystery thriller.',
        'Suggest games for a party night.',
        'What are fun activities for introverts?',
        'Create a short stand-up comedy routine.',
        'List trending shows to binge-watch.',
      ],
    },
  ].obs;



}
