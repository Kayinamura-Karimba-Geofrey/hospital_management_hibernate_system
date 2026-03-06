package com.example.Hospital_Management_System.service;

import com.example.Hospital_Management_System.entity.Doctors;
import com.example.Hospital_Management_System.entity.Patients;
import com.example.Hospital_Management_System.entity.util.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java. util.List;

public class PatientsService {
    public void createPatient(Patients patients){
        Session session = null;
        Transaction tx= null;
        try{
            session= HibernateUtil.getSessionFactory().openSession();
            tx= session.beginTransaction();
            session.merge(patients);
            tx.commit();
            System.out.println("saved patient:"+ patients.getName());
        }catch(Exception e){
            if(tx!=null){
                tx.rollback();

            }
            System.err.println("error saving the patient :"+ e.getMessage());
            e.printStackTrace();
        }finally{
            if(tx!= null){
                session.close();
            }

        }
    }
    public Patients getPatient(int id){
        Session session= null;
        try{
            session= HibernateUtil.getSessionFactory().openSession();
            return session.get(Patients.class,id);
        }catch(Exception e){
            System.err.println("Error retrieving Patient with id:"+id+":"+e.getMessage());
            e.printStackTrace();
            return null;
        }finally {
            if(session!= null){
                session.close();
            }
        }
    }

    public Patients getPatientById(int id){
        return getPatient(id);
    }

    //READ ALL
    public List<Patients> getAllPatients(){
        Session session= null;
        try{
            session= HibernateUtil.getSessionFactory().openSession();
            return session.createQuery("from Patients",Patients.class).list();

        }catch(Exception e){
            System.err.println("Error retrieving all patients:"+e.getMessage());
            e.printStackTrace();
            return List.of();

        }finally{
            if(session!=null){
                session.close();
            }
        }
    }
    public void updatePatient(Patients patient){
        Session session= null;
        Transaction tx= null;
        try{
            session= HibernateUtil.getSessionFactory().openSession();
            tx= session.beginTransaction();
            session.merge(patient);
            tx.commit();
            System.out.println("Patient updated:"+ patient.getName());
        }catch(Exception e){
            if(tx!=null){
                tx.rollback();
            }
            System.err.println("Error updating patient :"+ e.getMessage());
            e.printStackTrace();

        }finally{
            if(session!=null){
                session.close();
            }
        }
    }
    public void deletePatient(int id ){
        Session session= null;
        Transaction tx= null;

        try{
            session =HibernateUtil.getSessionFactory().openSession();
            tx= session.beginTransaction();
            Patients patients = session.get(Patients.class,id);
            if(patients !=null){
                session.remove(patients);
                System.out.println("patient deleted:"+patients.getName());

            }else{
                System.out.println("patient with id"+id+ "not found");
            }
            tx.commit();

        }catch(Exception e){
            if(tx!=null){
                tx.rollback();
            }
            System.err.println("error deleting patient with id "+id+":"+e.getMessage());
            e.printStackTrace();
        }finally{
            if(session!=null){
                session.close();
            }
        }
    }
}

