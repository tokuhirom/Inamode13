CREATE TRIGGER create_entry_history AFTER UPDATE ON entry FOR EACH ROW
BEGIN
    INSERT INTO entry_history (entry_id, body, ctime) VALUES (OLD.entry_id, OLD.body, OLD.mtime);
END;

