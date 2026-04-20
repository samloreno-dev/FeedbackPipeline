<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use OpenAI\Laravel\Facades\OpenAI;
use App\Models\Feedback;

class FeedbackController extends Controller
{
    public function store(Request $request): JsonResponse
    {
        $request->validate([
            'message' => 'required|string|max:1000',
        ]);

        $message = $request->input('message');

        // Simple profanity filter
        $blacklist = ['badword1', 'badword2']; // Expand as needed
        if (in_array(strtolower($message), $blacklist) || preg_match('/\b(bad|word)\b/i', $message)) {
            return response()->json(['error' => 'Profanity detected'], 422);
        }

        // AI Analysis with OpenAI GPT-4o-mini
        $analysis = $this->analyzeFeedback($message);

        // Save to DB
        $feedback = Feedback::create([
            'message' => $message,
            'analysis' => $analysis,
        ]);

        return response()->json([
            'success' => true,
            'id' => $feedback->id,
            'analysis' => $analysis,
        ]);
    }

    private function analyzeFeedback(string $message): string
    {
        try {
            $response = OpenAI::chat()->create([
                'model' => 'gpt-4o-mini',
                'messages' => [
                    ['role' => 'system', 'content' => 'Analyze this feedback for sentiment, spam risk, and key insights. Respond in JSON: {"sentiment": "positive/negative/neutral", "spam_risk": "low/medium/high", "insights": "brief summary"}'],
                    ['role' => 'user', 'content' => $message],
                ],
            ]);

            return $response->choices[0]->message->content;
        } catch (\Exception $e) {
            return json_encode(['sentiment' => 'unknown', 'spam_risk' => 'low', 'insights' => 'AI unavailable']);
        }
    }
}

