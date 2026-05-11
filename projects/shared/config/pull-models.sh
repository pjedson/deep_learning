set -e
OLLAMA_HOST="${OLLAMA_HOST:-http://ollama:11434}"

# Pull the models
pull_model() {
  local model="$1"
  echo "Pulling model: $model"
  # curl -sS -X POST "$OLLAMA_HOST/pull" -H "Content-Type: application/json" -d "{\"model\": \"$model\"}"
  python3 -c "
import ollama, sys
for chunk in ollama.pull('$model', stream=True):
  status = chunk.get('status','')
  completed =  chunk.get('completed') or 0
  total = chunk.get('total') or 0
  if total and completed is not None:
      pct = int(completed / total * 100)
      print(f'\r {status} {pct}%   ', end='', flush=True)
  else:
      print(f'\r  {status}  ', end='', flush=True)

print(f'\n $model ready.')
"
}

echo "=== Ollama model installer ==="
echo "Models are stored in the 'localai-ollama-models' Docker volume."
echo "They persist across container rebuilds - pulling only happens once."

pull_model "mistral"
pull_model "nomic-embed-text"

# pull_model "llama3"
# pull_model "codellama"
# pull_model "phi3"

echo ""
echo "=== All done. Run ollma list to verify. ==="
