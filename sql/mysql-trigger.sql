CREATE TRIGGER update_entry AFTER UPDATE ON entry FOR EACH ROW
BEGIN
    INSERT INTO entry_history (entry_id, body, ctime, revision, remote_addr) VALUES (OLD.entry_id, OLD.body, OLD.mtime, OLD.revision, OLD.remote_addr);
END;

