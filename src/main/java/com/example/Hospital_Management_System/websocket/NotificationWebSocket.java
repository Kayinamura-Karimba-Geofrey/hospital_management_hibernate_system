package com.example.Hospital_Management_System.websocket;

import jakarta.websocket.*;
import jakarta.websocket.server.PathParam;
import jakarta.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@ServerEndpoint("/notifications/{userId}")
public class NotificationWebSocket {

    private static final Map<Long, Session> sessions = new ConcurrentHashMap<>();

    @OnOpen
    public void onOpen(Session session, @PathParam("userId") Long userId) {
        sessions.put(userId, session);
        System.out.println("WebSocket opened for user: " + userId);
    }

    @OnClose
    public void onClose(Session session, @PathParam("userId") Long userId) {
        sessions.remove(userId);
        System.out.println("WebSocket closed for user: " + userId);
    }

    @OnError
    public void onError(Session session, Throwable throwable) {
        throwable.printStackTrace();
    }

    public static void sendNotification(Long userId, String message) {
        Session session = sessions.get(userId);
        if (session != null && session.isOpen()) {
            try {
                session.getBasicRemote().sendText(message);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}
