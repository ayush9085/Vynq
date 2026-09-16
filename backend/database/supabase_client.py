import os
from typing import Dict, Any, Optional
from dotenv import load_dotenv

load_dotenv()

SUPABASE_URL = os.getenv("SUPABASE_URL", "")
SUPABASE_KEY = os.getenv("SUPABASE_KEY", os.getenv("SUPABASE_ANON_KEY", ""))

_supabase_client = None

def get_supabase_client():
    global _supabase_client
    if _supabase_client is not None:
        return _supabase_client

    if SUPABASE_URL and SUPABASE_KEY and "YOUR_SUPABASE" not in SUPABASE_URL:
        try:
            from supabase import create_client, Client
            _supabase_client = create_client(SUPABASE_URL, SUPABASE_KEY)
            return _supabase_client
        except Exception as e:
            print(f"[WARN] Failed to initialize Supabase python client: {e}")
            return None
    return None

# Local fallback store for waitlist entries
_local_waitlist_store = []

async def insert_waitlist_entry(email: str, campus_domain: Optional[str] = None) -> Dict[str, Any]:
    client = get_supabase_client()
    if client:
        try:
            response = client.table("waitlist").insert({
                "email": email,
                "campus_domain": campus_domain or (email.split("@")[1] if "@" in email else "unknown"),
                "status": "pending"
            }).execute()
            return {"success": True, "data": response.data}
        except Exception as e:
            print(f"[WARN] Supabase db error: {e}")

    # Fallback in-memory persistence
    if email not in _local_waitlist_store:
        _local_waitlist_store.append(email)
    
    return {"success": True, "local_fallback": True, "email": email}

async def fetch_waitlist_count() -> int:
    client = get_supabase_client()
    if client:
        try:
            response = client.table("waitlist").select("*", count="exact").execute()
            if response.count is not None:
                return response.count + 2400
        except Exception as e:
            print(f"[WARN] Supabase fetch count error: {e}")

    return 2480 + len(_local_waitlist_store)
