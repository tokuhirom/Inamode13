CREATE TRIGGER update_entry AFTER UPDATE ON entry FOR EACH ROW
BEGIN
    INSERT INTO entry_history (entry_id, body, ctime, revision) VALUES (OLD.entry_id, OLD.body, OLD.mtime, OLD.revision);
END;

