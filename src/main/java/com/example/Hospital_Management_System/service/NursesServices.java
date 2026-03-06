package com.example.Hospital_Management_System.service;

import com.example.Hospital_Management_System.entity.Nurses;
import com.example.Hospital_Management_System.entity.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

public class NursesServices {
    public void createNurses(Nurses nurses){
        Session session = null;
        Transaction tx= null;
        try{
            session= HibernateUtil.getSessionFactory().openSession();
            tx= session.beginTransaction();
            session.merge(nurses);
            tx.commit();
            System.out.println("saved nurse:"+ nurses.getName());
        }catch(Exception e){
            if(tx!=null){
                tx.rollback();

            }
            System.err.println("error saving the nurse :"+ e.getMessage());
            e.printStackTrace();
        }finally{
            if(tx!= null){
                session.close();
            }

        }
    }
    public Nurses getNurses(int id){
        Session session= null;
        try{
            session= HibernateUtil.getSessionFactory().openSession();
            return session.get(Nurses.class,id);
        }catch(Exception e){
            System.err.println("Error retrieving nurse with id:"+id+":"+e.getMessage());
            e.printStackTrace();
            return null;
        }finally {
            if(session!= null){
                session.close();
            }
        }
    }

    public List<Nurses> getAllNurses(){
        Session session= null;
        try{
            session= HibernateUtil.getSessionFactory().openSession();
            return session.createQuery("from nurses",Nurses.class).list();

        }catch(Exception e){
            System.err.println("Error retrieving all nurses:"+e.getMessage());
            e.printStackTrace();
            return List.of();

        }finally{
            if(session!=null){
                session.close();
            }
        }
    }
    public void updateNurses(Nurses nurse){
        Session session= null;
        Transaction tx= null;
        try{
            session= HibernateUtil.getSessionFactory().openSession();
            tx= session.beginTransaction();
            session.merge(nurse);
            tx.commit();
            System.out.println("Nurse updated:"+ nurse.getName());
        }catch(Exception e){
            if(tx!=null){
                tx.rollback();
            }
            System.err.println("Error updating nurse :"+ e.getMessage());
            e.printStackTrace();

        }finally{
            if(session!=null){
                session.close();
            }
        }
    }
    public void deleteNurses(int id ){
        Session session= null;
        Transaction tx= null;

        try{
            session =HibernateUtil.getSessionFactory().openSession();
            tx= session.beginTransaction();
            Nurses nurses = session.get(Nurses.class,id);
            if(nurses !=null){
                session.remove(nurses);
                System.out.println("nurse deleted:"+nurses.getName());

            }else{
                System.out.println("nurse with id"+id+ "not found");
            }
            tx.commit();

        }catch(Exception e){
            if(tx!=null){
                tx.rollback();
            }
            System.err.println("error deleting nurse with id "+id+":"+e.getMessage());
            e.printStackTrace();
        }finally{
            if(session!=null){
                session.close();
            }
        }
    }
}



