package com.example.Hospital_Management_System.service;

import com.example.Hospital_Management_System.entity.Appointments;
import com.example.Hospital_Management_System.entity.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

public class AppointmentsService {
    public void createAppointments(Appointments appointments){
        Session session = null;
        Transaction tx= null;
        try{
            session= HibernateUtil.getSessionFactory().openSession();
            tx= session.beginTransaction();
            session.merge(appointments);
            tx.commit();
            System.out.println("saved Appointments:"+ appointments.getAppointmentDate());
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
    public Appointments getAppointment(int id){
        Session session= null;
        try{
            session= HibernateUtil.getSessionFactory().openSession();
            return session.get(Appointments.class,id);
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
    //READ ALL
    public List<Appointments> getAllAppointments(){
        Session session= null;
        try{
            session= HibernateUtil.getSessionFactory().openSession();
            return session.createQuery("from appointments",Appointments.class).list();

        }catch(Exception e){
            System.err.println("Error retrieving all appointments:"+e.getMessage());
            e.printStackTrace();
            return List.of();

        }finally{
            if(session!=null){
                session.close();
            }
        }
    }
    public void updateNurses(Appointments appointments){
        Session session= null;
        Transaction tx= null;
        try{
            session= HibernateUtil.getSessionFactory().openSession();
            tx= session.beginTransaction();
            session.merge(appointments);
            tx.commit();
            System.out.println("Appointment updated:"+ appointments.getAppointmentDate());
        }catch(Exception e){
            if(tx!=null){
                tx.rollback();
            }
            System.err.println("Error updating appointment :"+ e.getMessage());
            e.printStackTrace();

        }finally{
            if(session!=null){
                session.close();
            }
        }
    }
    public void deleteAppointments(int id ){
        Session session= null;
        Transaction tx= null;

        try{
            session =HibernateUtil.getSessionFactory().openSession();
            tx= session.beginTransaction();
            Appointments appointments= session.get(Appointments.class,id);
            if(appointments !=null){
                session.remove(appointments);
                System.out.println("appointment deleted:"+appointments.getAppointmentDate());

            }else{
                System.out.println("appointment with id"+id+ "not found");
            }
            tx.commit();

        }catch(Exception e){
            if(tx!=null){
                tx.rollback();
            }
            System.err.println("error deleting appointment with id "+id+":"+e.getMessage());
            e.printStackTrace();
        }finally{
            if(session!=null){
                session.close();
            }
        }
    }
}





